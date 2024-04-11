# Programming Techniques for Supercomputers - CAM project

## Background: Modelling 2D steady-state heat equation
This code project for the 10 ECTS PTfS module solves a linear system of equations to find a steady-state temperature distributen on a rectangular plate using the Conjugate Gradient (CG) and Preconditioned Conjugate Gradient (PCG) with symmetric Gauss-Seidel preconditioning methods.

Please see the tutorials for more information.

## Usage
1) Compile program by calling
    ```bash
    CXX=<compiler icpc or g++> make
    ```

   To compile with LIKWID use:
   ```bash
   LIKWID=on CXX=<compiler icpc or g++> make
   ```

2)  Run tests by running
    ```bash
    ./test
    ```

3)  Run performance tests by running
    ```bash
    ./perf <grid size y> <grid size x>
    ```
