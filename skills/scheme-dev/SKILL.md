---
name: scheme-dev
description: Implement or review one restricted Racket function or test unit for CS F301 Assignment 2.
---

# Scheme development

Target Racket 8.x with #lang racket/base. Work on one function, test file, or review
at a time. Preserve genuine prompts and accurate unit commits. Use kebab-case names
and a comment stating the recursive meaning and accumulator invariant where used.

Solution files contain definitions only, with no require/provide, top-level calls,
mutation, or load-time output. Allowed built-ins: define, lambda, let, let*, letrec,
named let, if, cond/else, and, or, not, begin, quote, cons, car, cdr, list, car/cdr
compositions through four levels, null?, pair?, eq?, assq, assoc, +, -, *, <, >, <=,
>=, =, max, display, newline. Only S2 may additionally use read.
Implement needed list operations explicitly; length, append, reverse, map, filter,
member, memq, list-ref, list-tail, vectors, strings, hashes, and loops are forbidden.

For trees, use left-before-right recursion and accumulators or continuation tails
to avoid repeated list concatenation. Height of empty is 0; its leaf count is 0.
For nested insertion, measure each original list before transforming its children.
An empty list is itself eligible. Do not traverse newly inserted atoms. The final
insert-if-short must have exactly one definition and delegate to make-inserter.
Use tail recursion for long flat list walks; cover 10,000 elements and depth 100.

Run the standalone test harnesses from the repository root:

```sh
racket tests/test_q3.rkt
racket tests/test_q4.rkt
```

The harness evaluates definitions in a fresh namespace, matching the grader's
appended-call behavior without adding exports to solution files. Test harnesses
may use testing facilities; the whitelist applies to the submitted solution code.

Before finishing, check all called built-ins against the whitelist, proper-list
base cases, traversal order, newline counts, unchanged atoms, original lengths,
single insert-if-short definition, and absence of output while loading. Known AI
failures: importing convenient list functions; using set! for counters; confusing
empty sublists with atoms; testing transformed lengths; inserting repeatedly into
new output; reversing map order; and defining a function correctly but calling it
at the top level, causing extra grader output.

