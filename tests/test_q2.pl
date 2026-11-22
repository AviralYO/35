:- use_module(library(plunit)).
:- ensure_loaded('../code/35_q2.pl').

% The oracle constructs ordinary Prolog arithmetic terms, not production nodes.
reference_tree([N], N).
reference_tree(Ns, T) :-
    append([A|As], [B|Bs], Ns),
    reference_tree([A|As], L), reference_tree([B|Bs], R),
    member(Op, ['+','-','*','/']), T =.. [Op,L,R].

reference_value(N, N) :- integer(N).
reference_value(T, V) :-
    compound(T), T =.. [Op,L,R],
    reference_value(L,A), reference_value(R,B),
    ( Op == '+' -> V is A+B
    ; Op == '-' -> V is A-B
    ; Op == '*' -> V is A*B
    ; B =\= 0, V is A div B, A =:= V*B
    ).

reference_equation(Ns, L=R) :-
    append([A|As], [B|Bs], Ns),
    reference_tree([A|As], L), reference_tree([B|Bs], R),
    reference_value(L,V), reference_value(R,V).

small_numbers([]).
small_numbers([N|Ns]) :- between(0,2,N), small_numbers(Ns).

:- begin_tests(q2).
test(pdf_seven_equations, true(Es ==
    ["4*2-5=3","4*2=5+3","4-2=5-3","4/2=5-3",
     "4=2*(5-3)","4=2+(5-3)","4=2+5-3"])) :-
    all_equations([4,2,5,3], Es), count_equations([4,2,5,3],7).
test(pdf_no_solution) :-
    \+ generate_equation([2,3,4],_), all_equations([2,3,4],[]),
    count_equations([2,3,4],0).
test(pdf_single_equation) :- all_equations([2,4,8],["2*4=8"]).
test(empty) :- \+ generate_equation([],_), all_equations([],[]).
test(singleton) :- \+ generate_equation([9],_), count_equations([9],0).
test(equal_pair) :- all_equations([12,12],["12=12"]).
test(unequal_pair) :- all_equations([12,21],[]).
test(zero_pair) :- all_equations([0,0],["0=0"]).
test(negative_division, [nondet]) :-
    combine('/',6,-3,-2,2), combine('/',-6,-3,2,2).
test(no_zero_division, [fail]) :- combine('/',1,0,_,_).
test(no_fractional_division, [fail]) :- combine('/',2,4,_,_).
test(no_fractional_intermediate, [fail]) :-
    expression([4,2,4],node('/',2,num(4),node('/',2,num(2),num(4))),_).
test(arbitrary_size_integers) :-
    all_equations([100000000000000000000,100000000000000000000],
                  ["100000000000000000000=100000000000000000000"]).
test(canonical_parentheses) :-
    forall(member(Tree-Expected,
      [node('*',2,node('+',1,num(4),num(2)),num(3))-"(4+2)*3",
       node('+',1,num(4),node('*',2,num(2),num(3)))-"4+2*3",
       node('*',2,node('/',2,num(8),num(4)),num(2))-"8/4*2",
       node('/',2,num(8),node('*',2,num(4),num(2)))-"8/(4*2)",
       node('-',1,node('-',1,num(1),num(2)),num(3))-"1-2-3",
       node('-',1,num(1),node('-',1,num(2),num(3)))-"1-(2-3)",
       node('+',1,num(1),node('+',1,num(2),num(3)))-"1+(2+3)",
       node('+',1,node('+',1,num(1),num(2)),num(3))-"1+2+3"]),
      (expression_text(Tree,Actual), assertion(Actual == Expected))).
test(exhaustive_small_inputs) :-
    forall((between(2,4,Len),length(Ns,Len),small_numbers(Ns)),
      (findall(T,reference_equation(Ns,T),Expected0),sort(Expected0,Expected),
       all_equations(Ns,Strings),
       maplist([S,T]>>read_term_from_atom(S,T,[]),Strings,Terms0),
       sort(Terms0,Terms), assertion(Terms == Expected),
       length(Strings,Count),length(Terms,Count),count_equations(Ns,Count),
       forall(member(S,Strings),assertion(string(S))))).
:- end_tests(q2).
