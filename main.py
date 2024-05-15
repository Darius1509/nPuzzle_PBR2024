from pyswip import Prolog


def is_valid_state(state):
    n = len(state)  #Number of rows
    m = len(state[0]) if state else 0  #Number of columns

    #Check if the grid is square and either 3x3 or 4x4
    if n != m or (n not in [3, 4]):
        return False, "State must be a 3x3 or 4x4 matrix"

    #Flatten the matrix and sort elements
    flat_state = [item for sublist in state for item in sublist]
    flat_state_sorted = sorted(flat_state)

    #Check for the correct elements in the matrix
    correct_elements = list(range(n * n))
    if flat_state_sorted != correct_elements:
        return False, f"State must contain all numbers from 0 to {n * n - 1}"

    return True, "State is valid"


def count_inversions(state):
    #Flatten the list and remove the blank (0)
    flat_list = [number for row in state for number in row if number != 0]
    inversions = 0
    for i in range(len(flat_list)):
        for j in range(i + 1, len(flat_list)):
            if flat_list[i] > flat_list[j]:
                inversions += 1
    return inversions


def find_blank_row(state):
    #Finds the row of the blank space (0), counting from the bottom
    n = len(state)
    for i in range(n):
        if 0 in state[i]:
            blank_row_from_bottom = n - i
            print(f"Blank is in row {blank_row_from_bottom} from the bottom")
            return blank_row_from_bottom


def is_solvable(state):
    inversions = count_inversions(state)
    blank_row = find_blank_row(state)
    n = len(state)

    print(f"Inversions: {inversions}")
    print(f"Blank row from bottom: {blank_row}")

    if n == 3:
        #For a 3x3 puzzle, solvable if inversions are even
        return inversions % 2 == 0
    elif n == 4:
        #For a 4x4 puzzle, check the blank row and inversion parity
        if blank_row % 2 == 0:  #Blank is on an even row from the bottom
            return inversions % 2 == 1  #Need odd inversions
        else:  #Blank is on an odd row from the bottom
            return inversions % 2 == 0  #Need even inversions


#Example usage
state_3x3_solvable = [[1, 2, 5], [8, 0, 4], [7, 6, 3]]  # Solvable
state_3x3_unsolvable = [[8, 1, 2], [0, 4, 3], [7, 6, 5]]  # Unsolvable due to an odd number of inversions

#For 4x4 grids
state_4x4_solvable = [[4, 0, 10, 9], [12, 5, 3, 15], [7, 8, 14, 6], [13, 2, 11, 1]]  # Solvable
state_4x4_unsolvable = [[3, 8, 6, 1], [5, 4, 10, 2], [9, 7, 12, 11], [13, 15, 14, 0]]  # Unsolvable

# Validate states
# print(is_valid_state(state_3x3_solvable))
# print(is_valid_state(state_3x3_unsolvable))
# print(is_valid_state(state_4x4_solvable))
# print(is_valid_state(state_4x4_unsolvable))

# print("3x3 Solvable?", is_solvable(state_3x3_solvable))
# print("3x3 Unsolvable?", is_solvable(state_3x3_unsolvable))
# print("4x4 Solvable?", is_solvable(state_4x4_solvable))
# print("4x4 Unsolvable?", is_solvable(state_4x4_unsolvable))

print('\n')

from pyswip import Prolog

def solve_puzzle3x3(initial_state):
    prolog = Prolog()
    prolog.consult("nPuzzleSolver3x3.pl")

    State = initial_state
    MovesList = []
    Modified_state = [('*' if x == 0 else x) for row in State for x in row]
    solution = prolog.query(f"ids({Modified_state}, {MovesList}).")
    print("Solution retrieved successfully!")  # Add this line to indicate the solution has been retrieved
    return solution

def solve_puzzle4x4(initial_state):
    prolog = Prolog()
    prolog.consult("nPuzzleSolver4x4.pl")

    State = initial_state
    MovesList = []
    Modified_state = [('*' if x == 0 else x) for row in State for x in row]
    solution = prolog.query(f"ids({Modified_state},{MovesList}).")
    print("Solution retrieved successfully!")
    return solution

# Example initial state for 3x3
initial_state_3x3 = [[1, 2, 5], [8, 0, 4], [7, 6, 3]]
solution = solve_puzzle3x3(initial_state_3x3)
for sol in solution:
    print(sol)

# Example initial state for 4x4
# initial_state_4x4 = [[15, 11, 13, 2], [8, 3, 10, 9], [1, 14, 5, 6], [12, 7, 4, 0]]
# solution = solve_puzzle4x4(initial_state_4x4)
# for sol in solution:
#     print(sol)


