:- use_module(library(lists)).

% split_nonempty(+Numbers, -Left, -Right): split at each internal boundary.
split_nonempty(Numbers, Left, Right) :-
    append(Left, Right, Numbers),
    Left = [_|_],
    Right = [_|_].