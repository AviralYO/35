:- use_module(library(lists)).

% split_nonempty(+Numbers, -Left, -Right): split at each internal boundary.
split_nonempty(Numbers, Left, Right) :-
    append(Left, Right, Numbers),
    Left = [_|_],
    Right = [_|_].

% combine(-Op, +LeftValue, +RightValue, -Value, -Precedence).
% Higher precedence numbers bind more tightly in the canonical printer.
combine('+', A, B, V, 1) :- V is A + B.
combine('-', A, B, V, 1) :- V is A - B.
combine('*', A, B, V, 2) :- V is A * B.
combine('/', A, B, V, 2) :-
    B =\= 0,
    0 =:= A rem B,
    V is A // B.