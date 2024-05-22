:- use_module(library(lists)).

ids(StartList, MovesList) :-
    list_to_state(StartList, StartState),
    goal_state(GoalState),
    (answer(StartState, GoalState, MovesList) -> true ; false).

list_to_state([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P], A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P).

goal_state(1/2/3/4/5/6/7/8/9/10/11/12/13/14/15/'*').

answer(State, Goal, BlankMoves) :-
    fFunction(State, Goal, 0, F),
    search([(State, 0, F, [], [])], Goal, MovesList, StatesList),
    reverse(MovesList, BlankMoves),
    reverse(StatesList, ReversedStatesList),
    show([start|BlankMoves], [State|ReversedStatesList]),
    true.

show([], _).
show([Move|Moves], [State|States]) :-
    State = A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P,
    format('~n~w~n~n', [Move]),
    format('~w ~w ~w ~w~n', [A, B, C, D]),
    format('~w ~w ~w ~w~n', [E, F, G, H]),
    format('~w ~w ~w ~w~n', [I, J, K, L]),
    format('~w ~w ~w ~w~n', [M, N, O, P]),
    show(Moves, States).

% A* algorithm

fFunction(State, Goal, Dn, Fn) :-
    hFunction(State, Goal, Hn),
    Fn is Dn + Hn.

search([(State, _, _, MovesList, List)|_], Goal, MovesList, List) :-
    isequal(State, Goal), !.
search([N|Ns], Goal, MovesList, List) :-
    expand(N, Children, Goal),
    insertAll(Children, Ns, Open),
    search(Open, Goal, MovesList, List).

insertAll([C|Cs], Open1, Open3) :-
    insert(C, Open1, Open2),
    insertAll(Cs, Open2, Open3).
insertAll([], Open, Open).

insert(B, [C|R], [B, C|R]) :- checkCost(B, C), !.
insert(B, [B1|R], [B1|S]) :- insert(B, R, S), !.
insert(B, [], [B]).

checkCost((_, _, F1, _, _), (_, _, F2, _, _)) :- F1 < F2.

expand((State, Depth, _, M, L), All_My_Children, Goal) :-
    findall((Child, D1, F, [Move|M], [Child|L]),
            (D1 is Depth + 1, move(State, Child, Move), fFunction(Child, Goal, D1, F)),
            All_My_Children).

isequal(X, X).

left(State, Goal) :-
    getList(State, L1),
    indexOf(L1, *, I1),
    isLeftValid(I1),
    NewSpace is I1 - 1,
    elementAt(Num, L1, NewSpace),
    swap_elements(L1, I1, NewSpace, L2),
    getState(L2, Goal).

right(State, Goal) :-
    getList(State, L1),
    indexOf(L1, *, I1),
    isRightValid(I1),
    NewSpace is I1 + 1,
    elementAt(Num, L1, NewSpace),
    swap_elements(L1, I1, NewSpace, L2),
    getState(L2, Goal).

up(State, Goal) :-
    getList(State, L1),
    indexOf(L1, *, I1),
    isUpValid(I1),
    NewSpace is I1 - 4,
    elementAt(Num, L1, NewSpace),
    swap_elements(L1, I1, NewSpace, L2),
    getState(L2, Goal).

down(State, Goal) :-
    getList(State, L1),
    indexOf(L1, *, I1),
    isDownValid(I1),
    NewSpace is I1 + 4,
    elementAt(Num, L1, NewSpace),
    swap_elements(L1, I1, NewSpace, L2),
    getState(L2, Goal).

isLeftValid(Space) :- X is mod(Space, 4), X \= 0.
isRightValid(Space) :- X is mod(Space, 4), X \= 3.
isUpValid(Space) :- Space >= 4.
isDownValid(Space) :- Space < 12.

swap_elements(L, I1, I2, R) :-
    nth0(I1, L, E1),
    nth0(I2, L, E2),
    set_elem(L, I1, E2, L2),
    set_elem(L2, I2, E1, R).

set_elem([_|T], 0, Elem, [Elem|T]).
set_elem([H|T], Index, Elem, [H|R]) :-
    Index > 0,
    Index1 is Index - 1,
    set_elem(T, Index1, Elem, R).

getList(A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P, [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]).

getState([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P], A/B/C/D/E/F/G/H/I/J/K/L/M/N/O/P).

elementAt(X, [X|_], 0).
elementAt(X, [_|L], K) :-
    K > 0,
    K1 is K - 1,
    elementAt(X, L, K1).

indexOf([Element|_], Element, 0) :- !.
indexOf([_|Tail], Element, Index) :-
    indexOf(Tail, Element, Index1),
    !,
    Index is Index1 + 1.

move(State, Child, left) :- left(State, Child).
move(State, Child, up) :- up(State, Child).
move(State, Child, right) :- right(State, Child).
move(State, Child, down) :- down(State, Child).

hFunction(State, Goal, H) :-
    getManhattanDistance(State, Goal, D),
    H is D.

getManhattanDistance(State, Goal, D) :-
    getList(State, L1),
    getList(Goal, L2),
    md(L1, L1, L2, D).

md([], _, _, 0).
md([X|Xs], S, G, D) :-
    (X \= * ->
     indexOf(S, X, I1),
     indexOf(G, X, I2),
     manD(I1, I2, D1),
     md(Xs, S, G, D2),
     D is D1 + D2;
     D1 = 0,
     md(Xs, S, G, D2),
     D is D1 + D2).

manD(Space1, Space2, D) :-
    getx(Space1, X1),
    gety(Space1, Y1),
    getx(Space2, X2),
    gety(Space2, Y2),
    mandist(X1/Y1, X2/Y2, D).

mandist(X/Y, X1/Y1, D) :-
    dif(X, X1, Dx),
    dif(Y, Y1, Dy),
    D is Dx + Dy.

dif(A, B, D) :- D is A - B, D >= 0.
dif(A, B, D) :- D is B - A, D > 0.

getx(P, X) :- M is mod(P, 4), M = 0, X is 4, !.
getx(P, X) :- X is mod(P, 4).

gety(P, Y) :- M is mod(P, 4), M = 0, Y is P // 4, !.
gety(P, Y) :- Y is truncate(P / 4 + 1).
