from pyswip import Prolog

# Initialize Prolog
prolog = Prolog()

# Load the Prolog file
prolog.consult("nPuzzleSolver3x3.pl")

# Define the Prolog query
start_list = [1, 2, 5, 8, '*', 4, 7, 6, 3]
query = f"ids({start_list}, MovesList)"

# Run the query and capture the output
result = list(prolog.query(query))

# Check if there's any result
if result:
    moves_list = result[0]['MovesList']
else:
    moves_list = []

# Print the captured MovesList
print("Captured MovesList:")
print(moves_list)

# Return the captured MovesList in a variable
captured_moves_list = moves_list