# ec-assignment-1
GAP Solver using intlinprog (MATLAB)
🔍 Description
This MATLAB script reads and processes 12 Generalized Assignment Problem (GAP) input files (gap1.txt to gap12.txt), solves each instance optimally using integer linear programming (intlinprog), and displays the results in a structured tabular format.

Each GAP instance assigns users to servers (or agents) while minimizing the total cost, subject to server capacity constraints and assignment feasibility.

📂 File Structure
gap1.txt, gap2.txt, ..., gap12.txt: Input files (each with multiple problem instances)
process_gap_files.m: Main function that orchestrates reading files and displaying results
optimize_gap.m: Subfunction that solves the GAP using intlinprog
display_results.m: Formats and prints the result matrix neatly in groups of 4 columns per row
📥 Input File Format (gapX.txt)
Each file contains one or more GAP instances:

<number_of_problems>
<server_count> <user_count>
<cost_matrix (user_count × server_count)>
<resource_matrix (user_count × server_count)>
<capacity_vector (server_count)>
The cost and resource matrices are stored in row-major order (read column-wise then transpose).

⚙️ How It Works
process_gap_files()

Reads each file sequentially.
For each instance, reads matrix dimensions and values.
Calls optimize_gap() to solve the instance.
Collects formatted outputs for final display.
optimize_gap()

Converts GAP to integer linear programming (ILP) format.
Uses intlinprog to compute the optimal binary assignment.
Reshapes the flat solution back to a matrix.
display_results()

Displays all results in a grid layout (4 files per row).
🧪 Requirements
MATLAB R2017b or later
Optimization Toolbox (for intlinprog)
▶️ How to Run
Place all 12 gapX.txt files in the same directory as the script, then run:

process_gap_files();
📊 Output
Output format:

gap1            gap2            gap3            gap4
s5-u10-1        s5-u10-1        s5-u10-1        s5-u10-1
s5-u10-2        s5-u10-2        s5-u10-2        s5-u10-2
...
Each sX-uY-Z indicates:

X servers
Y users
Z instance index
Followed by the total cost (objective value).
📌 Notes
The optimization problem is a minimization of cost.
Each user must be assigned to exactly one server.
Each server must not exceed its capacity constraint.
🧑‍💻 Author
Your Name rakesh kumar
University/Institute (nit jamshedpur )
Email (rakeshraj.dav@gmail.com)

📃 License
This code is for educational and research purposes only.
