---
name: prolog-dev
description: Implement or review one SWI-Prolog predicate or test unit for CS F301 Assignment 2.
---

# Prolog development

Target SWI-Prolog 9.x. Read the relevant assignment requirements before each unit.
Work on one predicate, test file, or review at a time. Preserve actual prompts verbatim;
never present assistant planning notes as user prompts or invent student contributions.
Commit each completed unit with an accurate description and author.

Use snake_case predicate names, uppercase variables, and a comment describing the
relation and intended argument modes. Keep clue/2 clauses independent and apply
negative checks only to ground candidate assignments. Enumerate each candidate once.
Only lists, apply, yall, and aggregate may be imported by solution files. Do not use
assert, retract, global state, initialization directives, or halt in solution files.
Only main/0 in P1 prints; every other exported task predicate is silent.

For P2, carry an expression tree and its integer value together. Reject zero divisors
and non-exact division at every node. Render the tree only after evaluation; never
parse a generated string to evaluate it. Parenthesize a left child of lower
precedence and a right child of equal or lower precedence.

Run from the repository root:

```sh
swipl -q -f code/35_q1.pl -g main -t halt
swipl -q -s tests/test_q1.pl -g run_tests -t halt
swipl -q -s tests/test_q2.pl -g run_tests -t halt
```

Replace id in paths after the group ID is confirmed. Test libraries are harness
dependencies, not imports in the submitted solution files.

Before finishing a unit, check termination for its documented modes, completeness
under backtracking, absence of duplicate proofs that inflate counts, groundness
before arithmetic or negation, exact output formatting, and allowed dependencies.
Known AI failures: treating negation as disequality on unbound variables; using
lowercase names as variables; forgetting quoted atoms 'AI' and 'c++'; accidentally
using floating division; conflating expression trees; imposing inactive clues;
printing on consult; and hiding nondeterminism with a cut before all valid answers.

