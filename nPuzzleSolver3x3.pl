ids(StartList, MovesList) :-
    list_to_state(StartList, StartState),
    start(StartState, State),
    length(Moves, N),
    dfs([State], Moves, Path), !,
    maplist(atom_string, Moves, MovesList),
    show([start|Moves], Path),
    format('~nmoves = ~w~n', [N]).

start(StartState, StartState).

list_to_state([A, B, C, D, E, F, G, H, I], state(A, B, C, D, E, F, G, H, I)).

dfs([State|States], [], Path) :-
    goal(State), !,
    reverse([State|States], Path).

dfs([State|States], [Move|Moves], Path) :-
    move(State, Next, Move),
    not(memberchk(Next, [State|States])),
    dfs([Next,State|States], Moves, Path).

show([], _).
show([Move|Moves], [State|States]) :-
    State = state(A, B, C, D, E, F, G, H, I),
    format('~n~w~n~n', [Move]),
    format('~w ~w ~w~n', [A, B, C]),
    format('~w ~w ~w~n', [D, E, F]),
    format('~w ~w ~w~n', [G, H, I]),
    show(Moves, States).

goal(state(A, B, C, D, E, F, G, H, I)) :-
    StateList = [A, B, C, D, E, F, G, H, I],
    check_order(StateList).

check_order([1, 2, 3, 4, 5, 6, 7, 8, *]).
check_order([1, 2, 3, 4, 5, 6, 7, *, 8]).
check_order([1, 2, 3, 4, 5, 6, *, 7, 8]).
check_order([1, 2, 3, 4, 5, *, 6, 7, 8]).
check_order([1, 2, 3, 4, *, 5, 6, 7, 8]).
check_order([1, 2, 3, *, 4, 5, 6, 7, 8]).
check_order([1, 2, *, 3, 4, 5, 6, 7, 8]).
check_order([1, *, 2, 3, 4, 5, 6, 7, 8]).
check_order([*, 1, 2, 3, 4, 5, 6, 7, 8]).

matches_order([], []).
matches_order([H|T1], [H|T2]) :- matches_order(T1, T2).
matches_order([*|T1], [_|T2]) :- matches_order(T1, T2).

% possible moves for the blank space (*)
move(State1, State2, Move) :-
    state_to_list(State1, List),
    nth0(Index, List, *),
    valid_move(Index, NextIndex, Move),
    swap(List, Index, NextIndex, NewList),
    list_to_state(NewList, State2).

state_to_list(state(A, B, C, D, E, F, G, H, I), [A, B, C, D, E, F, G, H, I]).

swap(List, Index, NextIndex, NewList) :-
    nth0(Index, List, Elem1),
    nth0(NextIndex, List, Elem2),
    set_elem(List, Index, Elem2, TempList),
    set_elem(TempList, NextIndex, Elem1, NewList).

set_elem([_|T], 0, Elem, [Elem|T]).
set_elem([H|T], Index, Elem, [H|R]) :-
    Index > 0,
    Index1 is Index - 1,
    set_elem(T, Index1, Elem, R).

valid_move(0, 1, right).
valid_move(0, 3, down).
valid_move(1, 0, left).
valid_move(1, 2, right).
valid_move(1, 4, down).
valid_move(2, 1, left).
valid_move(2, 5, down).
valid_move(3, 0, up).
valid_move(3, 4, right).
valid_move(3, 6, down).
valid_move(4, 1, up).
valid_move(4, 3, left).
valid_move(4, 5, right).
valid_move(4, 7, down).
valid_move(5, 2, up).
valid_move(5, 4, left).
valid_move(5, 8, down).
valid_move(6, 3, up).
valid_move(6, 7, right).
valid_move(7, 4, up).
valid_move(7, 6, left).
valid_move(7, 8, right).
valid_move(8, 5, up).
valid_move(8, 7, left).
