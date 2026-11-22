# P1: count and repair

With the original clues, the result is **N = 3**:

```prolog
count_solutions([1,2,3,4,5,6,7,8], N).
% N = 3.
```

The puzzle is satisfiable but underdetermined. Its eight clues do not determine a
unique assignment. All three solutions are listed below; each cell is
`department / language / project`.

| Friend | Solution 1 | Solution 2 | Solution 3 |
| --- | --- | --- | --- |
| Alex | design / java / AI | design / java / embedded | testing / python / embedded |
| Ben | development / javascript / web | development / javascript / web | development / javascript / web |
| Carla | research / c++ / data | testing / python / AI | design / java / AI |
| Dana | testing / python / embedded | research / c++ / data | research / c++ / data |

The added clue is:

> The friend working in the testing department prefers the AI project.

It refers only to attributes and contains no friend's name. It is false in
solutions 1 and 3, where the testing department prefers embedded, and true in
solution 2. Therefore:

```prolog
count_solutions([1,2,3,4,5,6,7,8,9], N).
% N = 1.
```

The retained assignment, in the required Prolog representation, is:

```prolog
[p('Alex',design,java,embedded),
 p('Ben',development,javascript,web),
 p('Carla',testing,python,'AI'),
 p('Dana',research,'c++',data)]
```

`main/0` intentionally solves clues 1 through 8, as P1.a asks. It prints solution 1
under the current enumeration order. Clue 9 is used only when explicitly selected.
With no active clues there are `(4!)^3 = 13,824` assignments. The tests verify this,
the independence of every numbered clue, and the counts before and after repair.
