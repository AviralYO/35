"""Run the four native-language suites and audit submitted Scheme identifiers."""
import argparse
import os
import pathlib
import re
import shutil
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
BASE = set("define lambda let let* letrec if cond else and or not begin quote cons car cdr list null? pair? eq? assq assoc + - * < > <= >= = max display newline".split())
BASE.update("c" + middle + "r" for middle in
            ("".join(bits) for size in range(1, 5)
             for bits in __import__("itertools").product("ad", repeat=size)))


def parse_scheme(text):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "#lang racket/base":
        raise ValueError("Expected #lang racket/base")
    body = "\n".join(line.split(";", 1)[0] for line in lines[1:])
    if '"' in body or "#" in body:
        raise ValueError("Strings and reader extensions are not allowed")
    tokens = iter(re.findall(r"[()]|'|[^\s()']+", body))

    def read(token):
        if token == "(":
            result = []
            for next_token in tokens:
                if next_token == ")":
                    return result
                result.append(read(next_token))
            raise ValueError("Unclosed list")
        if token == ")":
            raise ValueError("Unexpected closing parenthesis")
        if token == "'":
            return ["quote", read(next(tokens))]
        return int(token) if re.fullmatch(r"-?\d+", token) else token

    return [read(token) for token in tokens]


def audit_scheme(path, allow_read):
    forms = parse_scheme(path.read_text(encoding="utf-8"))
    definitions = []
    for form in forms:
        if not (isinstance(form, list) and len(form) >= 3 and form[0] == "define"
                and isinstance(form[1], list) and form[1]):
            raise ValueError(f"{path.name}: expected function definitions only")
        definitions.append(form[1][0])
    if len(set(definitions)) != len(definitions):
        raise ValueError(f"{path.name}: duplicate function definition")
    allowed = BASE | ({"read"} if allow_read else set())

    def visit(expr, env):
        if isinstance(expr, int):
            return
        if isinstance(expr, str):
            if expr not in env and expr not in allowed:
                raise ValueError(f"{path.name}: forbidden or unbound identifier {expr}")
            return
        if not expr:
            raise ValueError("Unquoted empty application")
        head = expr[0]
        if head == "quote":
            if len(expr) != 2:
                raise ValueError("Invalid quote")
            return
        if head == "lambda":
            local = env | set(expr[1])
            for body in expr[2:]:
                visit(body, local)
            return
        if head in ("let", "let*", "letrec"):
            named = head == "let" and isinstance(expr[1], str)
            bindings = expr[2] if named else expr[1]
            local = env | ({expr[1]} if named else set())
            if head == "letrec":
                local |= {binding[0] for binding in bindings}
            for name, value in bindings:
                visit(value, local if head in ("let*", "letrec") else env)
                if head == "let*":
                    local |= {name}
            local |= {binding[0] for binding in bindings}
            for body in expr[3:] if named else expr[2:]:
                visit(body, local)
            return
        if head == "cond":
            for clause in expr[1:]:
                for item in clause:
                    if item != "else":
                        visit(item, env)
            return
        for part in expr:
            visit(part, env)

    globals_ = set(definitions)
    for form in forms:
        local = globals_ | set(form[1][1:])
        for body in form[2:]:
            visit(body, local)
    if allow_read and definitions.count("insert-if-short") != 1:
        raise ValueError("Expected exactly one insert-if-short definition")
    print(f"PASS whitelist and definitions audit: {path.name}", flush=True)


def runtime(explicit, relative, executable):
    candidate = explicit or os.environ.get(executable.upper())
    local = ROOT / relative
    candidate = candidate or (str(local) if local.is_file() else shutil.which(executable))
    if not candidate:
        raise SystemExit(f"Missing {executable}; install the assigned major version or pass --{executable}.")
    return candidate


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--swipl")
    parser.add_argument("--racket")
    args = parser.parse_args()
    swipl = runtime(args.swipl, ".tools/swipl/bin/swipl.exe", "swipl")
    racket = runtime(args.racket, ".tools/racket/Racket.exe", "racket")
    for binary, flag, version_pattern in [(swipl, "--version", r"version 9\."),
                                          (racket, "--version", r"v8\.")]:
        result = subprocess.run([binary, flag], capture_output=True, text=True, check=True)
        print(result.stdout.strip(), flush=True)
        if not re.search(version_pattern, result.stdout):
            raise SystemExit("Runtime does not match the assignment's required major version")
    for number in (3, 4):
        matches = list((ROOT / "code").glob(f"*_q{number}.rkt"))
        if len(matches) != 1:
            raise SystemExit(f"Expected one solution for q{number}")
        audit_scheme(matches[0], number == 4)
    commands = [
        [swipl, "-q", "-s", "tests/test_q1.pl", "-g", "run_tests", "-t", "halt"],
        [swipl, "-q", "-s", "tests/test_q2.pl", "-g", "run_tests", "-t", "halt"],
        [racket, "tests/test_q3.rkt"], [racket, "tests/test_q4.rkt"],
    ]
    for command in commands:
        subprocess.run(command, cwd=ROOT, check=True)
    for source in sorted((ROOT / "code").iterdir()):
        command = ([racket, str(source)] if source.suffix == ".rkt" else
                   [swipl, "-q", "-f", str(source), "-g", "true", "-t", "halt"])
        result = subprocess.run(command, cwd=ROOT, capture_output=True, text=True, check=True)
        if result.stdout or result.stderr:
            raise SystemExit(f"Unexpected output when loading {source.name}: {result.stdout}{result.stderr}")
        print(f"PASS silent standalone load: {source.name}", flush=True)
    print("All four suites, whitelist audits, and load checks passed.", flush=True)


if __name__ == "__main__":
    main()
