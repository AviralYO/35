:- use_module(library(lists)).

% candidate(-Solution): each column is a permutation of its four legal values.
candidate([p('Alex', DA, LA, PA), p('Ben', DB, LB, PB),
           p('Carla', DC, LC, PC), p('Dana', DD, LD, PD)]) :-
    permutation([research, development, design, testing], [DA, DB, DC, DD]),
    permutation([python, java, 'c++', javascript], [LA, LB, LC, LD]),
    permutation(['AI', web, embedded, data], [PA, PB, PC, PD]).

% solve(+Active, -Solution): a candidate satisfies every selected clue.
solve(Active, Solution) :-
    candidate(Solution),
    forall(member(Number, Active), clue(Number, Solution)).

% count_solutions(+Active, -N): N counts all assignments satisfying Active.
count_solutions(Active, N) :-
    findall(Solution, solve(Active, Solution), Solutions),
    length(Solutions, N).