import tkinter as tk
from tkinter import messagebox
from pyswip import Prolog
import io
from contextlib import redirect_stdout


def is_valid_state(state):
    n = len(state)  # Number of rows
    m = len(state[0]) if state else 0  # Number of columns

    if n != m or (n not in [3, 4]):
        return False, "State must be a 3x3 or 4x4 matrix"

    flat_state = [item for sublist in state for item in sublist]
    flat_state_sorted = sorted(flat_state)

    correct_elements = list(range(n * n))
    if flat_state_sorted != correct_elements:
        return False, f"State must contain all numbers from 0 to {n * n - 1}"

    return True, "State is valid"


def count_inversions(state):
    flat_list = [number for row in state for number in row if number != 0]
    inversions = 0
    for i in range(len(flat_list)):
        for j in range(i + 1, len(flat_list)):
            if flat_list[i] > flat_list[j]:
                inversions += 1
    return inversions


def find_blank_row(state):
    n = len(state)
    for i in range(n):
        if 0 in state[i]:
            return n - i


def is_solvable(state):
    inversions = count_inversions(state)
    blank_row = find_blank_row(state)
    n = len(state)

    if n == 3:
        return inversions % 2 == 0
    elif n == 4:
        if blank_row % 2 == 0:
            return inversions % 2 == 1
        else:
            return inversions % 2 == 0


def solve_puzzle3x3(initial_state):
    prolog = Prolog()
    prolog.consult("nPuzzleSolver3x3.pl")
    State = [('*' if x == 0 else x) for row in initial_state for x in row]
    query = f"ids({State}, MovesList)"

    # Run the query and capture the output
    result = list(prolog.query(query))

    # Check if there's any result
    if result:
        moves_list = result[0]['MovesList']
        # Decode byte literals to strings
        moves_list = [move.decode('utf-8') for move in moves_list]
    else:
        moves_list = []
    return moves_list


def solve_puzzle4x4(initial_state):
    prolog = Prolog()
    prolog.consult("nPuzzleSolver4x4.pl")
    State = [('*' if x == 0 else x) for row in initial_state for x in row]
    MovesList = []
    solution = prolog.query(f"ids({State}, {MovesList}).")
    return solution


class PuzzleGUI(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("n-Puzzle Solver")
        self.geometry("400x400")

        self.size = 3
        self.entries = []

        self.create_widgets()

    def create_widgets(self):
        self.size_var = tk.IntVar(value=3)

        tk.Radiobutton(self, text="3x3", variable=self.size_var, value=3, command=self.update_grid).pack()
        tk.Radiobutton(self, text="4x4", variable=self.size_var, value=4, command=self.update_grid).pack()

        self.grid_frame = tk.Frame(self)
        self.grid_frame.pack()

        self.update_grid()

        self.solve_button = tk.Button(self, text="Solve!", command=self.solve_puzzle)
        self.solve_button.pack(pady=10)

        self.result_text = tk.Text(self, height=10, width=40)
        self.result_text.pack(pady=10)

    def update_grid(self):
        for widget in self.grid_frame.winfo_children():
            widget.destroy()

        self.entries = []
        self.size = self.size_var.get()
        for i in range(self.size):
            row_entries = []
            for j in range(self.size):
                entry = tk.Entry(self.grid_frame, width=5)
                entry.grid(row=i, column=j, padx=5, pady=5)
                row_entries.append(entry)
            self.entries.append(row_entries)

    def solve_puzzle(self):
        try:
            state = [[int(self.entries[i][j].get()) for j in range(self.size)] for i in range(self.size)]
        except ValueError:
            messagebox.showerror("Invalid input", "Please enter valid numbers in the grid.")
            return

        valid, message = is_valid_state(state)
        if not valid:
            messagebox.showerror("Invalid state", message)
            return

        if not is_solvable(state):
            messagebox.showerror("Unsolvable", "The puzzle is unsolvable.")
            return

        if self.size == 3:
            solution = solve_puzzle3x3(state)
        else:
            solution = solve_puzzle4x4(state)

        self.result_text.delete("1.0", tk.END)
        self.result_text.insert(tk.END, "Solution:\n")
        for move in solution:
            self.result_text.insert(tk.END, f"{move}\n")


if __name__ == "__main__":
    app = PuzzleGUI()
    app.mainloop()