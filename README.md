# CS F301 Principles of Programming Languages - Assignment 2

Prepared assignment files for **group 35**: four definition-only solutions,
four test files, two development skills, prompt records, and the P1 report.
This clean copy has no .git directory or previous Git history. Initialize Git
yourself when ready. See [SUBMISSION_CHECKLIST.md](SUBMISSION_CHECKLIST.md).

| Problem | Source | Required entry points | Tests |
| --- | --- | --- | --- |
| P1 | code/35_q1.pl | main/0, clue/2, count_solutions/2 | tests/test_q1.pl |
| P2 | code/35_q2.pl | generate_equation/2, all_equations/2, count_equations/2 | tests/test_q2.pl |
| S1 | code/35_q3.rkt | print-inorder, print-all-traversals, print-height-and-leaves | tests/test_q3.rkt |
| S2 | code/35_q4.rkt | my-length, my-map, make-inserter, insert-if-short, print-insert-result | tests/test_q4.rkt |

The repository root corresponds to `35/` in the assignment's layout. Use `35`
as the final repository/clone directory name. Group members
are in [MEMBERS.md](MEMBERS.md). The puzzle result is in [P1_REPORT.md](P1_REPORT.md).

## Running checks

With Python, SWI-Prolog 9.x, and Racket 8.x on PATH:

```sh
python tools/run_tests.py
```

Install SWI-Prolog 9.x and Racket 8.x on PATH, or pass their executable locations
with `--swipl PATH --racket PATH`. Runtime binaries are not included in this
shareable folder. Native test commands are:

```sh
swipl -q -s tests/test_q1.pl -g run_tests -t halt
swipl -q -s tests/test_q2.pl -g run_tests -t halt
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```

The test harnesses may use testing facilities. The assignment's library/built-in
restrictions apply to the four submitted source files; the runner audits Scheme
identifiers against that whitelist and verifies silent standalone loading.

## Grader behavior

Commands for group 35:

```sh
swipl -q -f code/35_q1.pl -g main -t halt
swipl -q -f code/35_q1.pl -g "count_solutions([1,2,3,4,5,6,7,8],N),writeln(N)" -t halt
swipl -q -f code/35_q2.pl -g "all_equations([4,2,5,3],Es),writeln(Es)" -t halt
racket code/35_q3.rkt
racket code/35_q4.rkt
```

Both standalone Racket commands deliberately print nothing. The grader appends
its calls. For S2 it appends `(print-insert-result)`, then provides `x`, `lst`, and
`n` on standard input. Do not add a top-level call to either solution file.

## Algorithms to understand for the viva

P1 enumerates one permutation per attribute column, then applies only selected
clues to ground candidates. `findall/3` counts those assignments. There are three
original solutions, and clue 9 keeps exactly one. Negated checks happen after
generation, so they never reject an unbound variable prematurely.

P2 enumerates every equality boundary and every ordered binary expression tree
on each side. Each node carries its exact integer value and display precedence.
Division checks a nonzero divisor and zero remainder at that node. The serializer
parenthesizes left children with lower precedence and right children with equal
or lower precedence, so `1+(2+3)` remains distinct from `1+2+3`. Search is
exponential, as exhaustive enumeration of all trees and operators is required.

S1 schedules pending subtrees and values in the desired visitation order, keeping
left-before-right traversal. It accumulates values backwards and restores them
with its own tail-recursive loop. Statistics carry node depths, maximum height,
and leaf count explicitly. Each traversal and statistics pass takes linear time
in the number of nodes and uses no forbidden list primitives.

S2 closes over `x` and the length predicate. For each original list, it measures
the top-level length, recursively transforms original sublists (including empty
lists), and conditionally prepends `x`. `my-length` and `my-map` are tail-recursive
for long flat lists. The inserted value is never traversed again. Work is linear
in the total original list cells; recursive nesting follows the input depth.
