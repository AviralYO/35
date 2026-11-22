# Validation record

All submitted solution files were verified with **SWI-Prolog 9.2.9 (x64-win64)**
and **Racket 8.18 [cs]**, matching the assigned major versions.

| Suite | Result | Main coverage |
| --- | --- | --- |
| P1 | 9 tests passed | 13,824 candidates; every clue checked independently; selectable clues; 3 original solutions; 1 repaired solution; exact printing |
| P2 | 15 tests passed | Exact PDF answers; short/no-solution inputs; zero and non-exact division; canonical parentheses; independent oracle for all 117 lists of length 2-4 over 0,1,2 |
| S1 | 999 checks passed | PDF output; empty/leaf/symbol trees; all 197 tree shapes through 6 nodes; 10,000-node skewed tree |
| S2 | 3,524 checks passed | All PDF I/O; map order; higher-order predicates; 500 seeded random nested lists; depth 100; flat/nested lists of 10,000 elements |

Both Scheme files passed the identifier whitelist and definition-only audits.
All four source files loaded silently under standalone grader-style commands.
Both required skill files passed the skill-creator validator.
The group-ID helper was verified in an isolated copy: invalid IDs were rejected,
all four filenames and test paths were updated for a valid ID, prompt hashes were
unchanged, and every native test and audit passed again on the renamed files.

Run `python tools/run_tests.py` to reproduce the native checks. Python is used for
the developer runner; the four solutions themselves have no Python dependency.
The native test harnesses can also be run directly using the README commands.

The isolated runtime archives were downloaded from the official
[SWI-Prolog release](https://www.swi-prolog.org/download/stable/bin/swipl-9.2.9-1.x64.exe.envelope)
and [Racket 8.18 release](https://download.racket-lang.org/releases/8.18/).
Their SHA256 checksums matched the published values:

```text
SWI-Prolog: 0e6dbf5f4bb245344a257f2715f5d793d17870dee9eea1735ccb67b35f1e037c
Racket:     f74ee030f4c357eae85513ee33fa0430d6c9b1accec83cf00852407110c77f3f
```

Runtime binaries and PDF inspection images stay in ignored local directories;
they are not part of the Git submission. Current tests do not prove correctness
for all possible inputs, and exhaustive equation enumeration has exponential cost.
