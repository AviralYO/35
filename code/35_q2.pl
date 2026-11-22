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

% expression(+Numbers, -Tree, -Value): every ordered binary expression tree.
expression([Number], num(Number), Number) :-
    integer(Number),
    Number >= 0.
expression(Numbers, node(Op, Precedence, Left, Right), Value) :-
    split_nonempty(Numbers, LeftNumbers, RightNumbers),
    expression(LeftNumbers, Left, LeftValue),
    expression(RightNumbers, Right, RightValue),
    combine(Op, LeftValue, RightValue, Value, Precedence).

% operand_text(+Tree, +ParentPrecedence, +Side, -Text).
operand_text(Tree, ParentPrecedence, Side, Text) :-
    expression_text(Tree, Raw),
    ( Tree = node(_, ChildPrecedence, _, _),
      ( ChildPrecedence < ParentPrecedence
      ; Side == right, ChildPrecedence =:= ParentPrecedence
      )
    -> atomics_to_string(['(', Raw, ')'], Text)
    ;  Text = Raw
    ).