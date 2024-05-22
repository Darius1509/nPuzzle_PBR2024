ids(StartList, MovesList) :-
    list_to_state(StartList, StartState),
    start(StartState, State),
    length(Moves, N),
    dfs([State], Moves, Path), !,
    maplist(atom_string, Moves, MovesList),  % Convert moves to strings
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

move(state(*, B, C, D, E, F, G, H, J), state(B, *, C, D, E, F, G, H, J), right).
move(state(*, B, C, D, E, F, G, H, J), state(D, B, C, *, E, F, G, H, J), down).

move(state(A, *, C, D, E, F, G, H, J), state(*, A, C, D, E, F, G, H, J), left).
move(state(A, *, C, D, E, F, G, H, J), state(A, C, *, D, E, F, G, H, J), right).
move(state(A, *, C, D, E, F, G, H, J), state(A, E, C, D, *, F, G, H, J), down).

move(state(A, B, *, D, E, F, G, H, J), state(A, *, B, D, E, F, G, H, J), left).
move(state(A, B, *, D, E, F, G, H, J), state(A, B, F, D, E, *, G, H, J), down).

move(state(A, B, C, *, E, F, G, H, J), state(*, B, C, A, E, F, G, H, J), up).
move(state(A, B, C, *, E, F, G, H, J), state(A, B, C, E, *, F, G, H, J), right).
move(state(A, B, C, *, E, F, G, H, J), state(A, B, C, G, E, F, *, H, J), down).

move(state(A, B, C, D, *, F, G, H, J), state(A, *, C, D, B, F, G, H, J), up).
move(state(A, B, C, D, *, F, G, H, J), state(A, B, C, D, F, *, G, H, J), right).
move(state(A, B, C, D, *, F, G, H, J), state(A, B, C, D, H, F, G, *, J), down).
move(state(A, B, C, D, *, F, G, H, J), state(A, B, C, *, D, F, G, H, J), left).

move(state(A, B, C, D, E, *, G, H, J), state(A, B, *, D, E, C, G, H, J), up).
move(state(A, B, C, D, E, *, G, H, J), state(A, B, C, D, *, E, G, H, J), left).
move(state(A, B, C, D, E, *, G, H, J), state(A, B, C, D, E, J, G, H, *), down).

move(state(A, B, C, D, E, F, *, H, J), state(A, B, C, D, E, F, H, *, J), left).
move(state(A, B, C, D, E, F, *, H, J), state(A, B, C, *, E, F, D, H, J), up).

move(state(A, B, C, D, E, F, G, *, J), state(A, B, C, D, E, F, *, G, J), left).
move(state(A, B, C, D, E, F, G, *, J), state(A, B, C, D, *, F, G, E, J), up).
move(state(A, B, C, D, E, F, G, *, J), state(A, B, C, D, E, F, G, J, *), right).

move(state(A, B, C, D, E, F, G, H, *), state(A, B, C, D, E, *, G, H, F), up).
move(state(A, B, C, D, E, F, G, H, *), state(A, B, C, D, E, F, G, *, H), left).
