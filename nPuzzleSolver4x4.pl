ids(StartList, MovesList) :-
    list_to_state(StartList, StartState),
    start(StartState, State),
    length(Moves, N),
    dfs([State], Moves, Path), !,
    maplist(atom_string, Moves, MovesList),  % Convert moves to strings
    show([start|Moves], Path),
    format('~nmoves = ~w~n', [N]).

start(StartState, StartState).

list_to_state([A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P], state(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)).

dfs([State|States], [], Path) :-
    goal(State), !,
    reverse([State|States], Path).

dfs([State|States], [Move|Moves], Path) :-
    move(State, Next, Move),
    not(memberchk(Next, [State|States])),
    dfs([Next,State|States], Moves, Path).

show([], _).
show([Move|Moves], [State|States]) :-
    State = state(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P),
    format('~n~w~n~n', [Move]),
    format('~w ~w ~w ~w~n', [A, B, C, D]),
    format('~w ~w ~w ~w~n', [E, F, G, H]),
    format('~w ~w ~w ~w~n', [I, J, K, L]),
    format('~w ~w ~w ~w~n', [M, N, O, P]),
    show(Moves, States).

goal(state(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P)) :-
    StateList = [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P],
    check_order(StateList).

check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, *]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, *, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, *, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, *, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, *, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, *, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, 9, *, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, 8, *, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, 7, *, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, 6, *, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, 5, *, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, 4, *, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, 3, *, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, 2, *, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([1, *, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).
check_order([*, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]).

matches_order([], []).
matches_order([H|T1], [H|T2]) :- matches_order(T1, T2).
matches_order([*|T1], [_|T2]) :- matches_order(T1, T2).

% Define possible moves for the blank space (*)
move(State1, State2, Move) :-
    state_to_list(State1, List),
    nth0(Index, List, *),
    valid_move(Index, NextIndex, Move),
    swap(List, Index, NextIndex, NewList),
    list_to_state(NewList, State2).

% Convert state to list representation
state_to_list(state(A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P), [A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P]).

% Swap elements at positions Index and NextIndex in the list
swap(List, Index, NextIndex, NewList) :-
    nth0(Index, List, Elem1),
    nth0(NextIndex, List, Elem2),
    set_elem(List, Index, Elem2, TempList),
    set_elem(TempList, NextIndex, Elem1, NewList).

% Set element at specific position in the list
set_elem([_|T], 0, Elem, [Elem|T]).
set_elem([H|T], Index, Elem, [H|R]) :-
    Index > 0,
    Index1 is Index - 1,
    set_elem(T, Index1, Elem, R).

% Define valid moves for each position of the blank space
valid_move(0, 1, right).
valid_move(0, 4, down).
valid_move(1, 0, left).
valid_move(1, 2, right).
valid_move(1, 5, down).
valid_move(2, 1, left).
valid_move(2, 3, right).
valid_move(2, 6, down).
valid_move(3, 2, left).
valid_move(3, 7, down).
valid_move(4, 0, up).
valid_move(4, 5, right).
valid_move(4, 8, down).
valid_move(5, 1, up).
valid_move(5, 4, left).
valid_move(5, 6, right).
valid_move(5, 9, down).
valid_move(6, 2, up).
valid_move(6, 5, left).
valid_move(6, 7, right).
valid_move(6, 10, down).
valid_move(7, 3, up).
valid_move(7, 6, left).
valid_move(7, 11, down).
valid_move(8, 4, up).
valid_move(8, 9, right).
valid_move(8, 12, down).
valid_move(9, 5, up).
valid_move(9, 8, left).
valid_move(9, 10, right).
valid_move(9, 13, down).
valid_move(10, 6, up).
valid_move(10, 9, left).
valid_move(10, 11, right).
valid_move(10, 14, down).
valid_move(11, 7, up).
valid_move(11, 10, left).
valid_move(11, 15, down).
valid_move(12, 8, up).
valid_move(12, 13, right).
valid_move(13, 9, up).
valid_move(13, 12, left).
valid_move(13, 14, right).
valid_move(14, 10, up).
valid_move(14, 13, left).
valid_move(14, 15, right).
valid_move(15, 11, up).
valid_move(15, 14, left).