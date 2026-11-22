:- use_module(library(plunit)).
:- ensure_loaded('../code/35_q1.pl').

% Independent checks phrase clues as forbidden combinations or implications.
reference_clue(1, S) :-
    \+ member(p('Dana', _, _, 'AI'), S),
    \+ member(p(_, research, _, 'AI'), S).
reference_clue(2, [p('Alex', D, L, _)|_]) :- D \= development, L \= 'c++'.
reference_clue(3, S) :- forall(member(p(_, testing, L, _), S), L == python).
reference_clue(4, [_,p('Ben', D, _, P),_,_]) :- P == web, D \= testing.
reference_clue(5, S) :- forall(member(p(_, D, java, _), S), D == design).
reference_clue(6, [_,_,p('Carla', D, _, P),_]) :- P \= embedded, D \= development.
reference_clue(7, [_,_,_,p('Dana', D, L, _)]) :-
    L \= java, memberchk(D, [research,testing]).
reference_clue(8, S) :-
    forall(member(p(_, D, L, data), S), (D == research, L \= javascript)).
reference_clue(9, S) :- forall(member(p(_, testing, _, P), S), P == 'AI').

:- begin_tests(q1).
test(empty_active_uses_all_assignments) :- count_solutions([], 13824).
test(candidates_unique) :-
    findall(S, candidate(S), Ss), sort(Ss, Unique),
    length(Ss, 13824), length(Unique, 13824).
test(each_clue_matches_independent_truth_table) :-
    forall((candidate(S), between(1,9,N)),
           (reference_clue(N,S) -> assertion(clue(N,S)); assertion(\+ clue(N,S)))).
test(original_count) :- count_solutions([1,2,3,4,5,6,7,8], 3).
test(repair_count) :- count_solutions([1,2,3,4,5,6,7,8,9], 1).
test(repair_solution, true(S ==
    [p('Alex',design,java,embedded), p('Ben',development,javascript,web),
     p('Carla',testing,python,'AI'), p('Dana',research,'c++',data)])) :-
    findall(X, solve([1,2,3,4,5,6,7,8,9],X), [S]).
test(selected_clues_only) :-
    forall(member(Active, [[1],[4],[8],[9],[1,4,8],[7,2,5],[2,2,1]]),
      (findall(S, (candidate(S),forall(member(N,Active),reference_clue(N,S))), Ss),
       length(Ss, Count), count_solutions(Active, Count))).
test(unknown_clue_has_no_solutions) :- count_solutions([99], 0).
test(main_exact_format, true(Output ==
    "Alex = [design, java, AI]\nBen = [development, javascript, web]\nCarla = [research, c++, data]\nDana = [testing, python, embedded]\n")) :-
    with_output_to(string(Output), main).
:- end_tests(q1).
