pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/matSub.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemMul.circom";
include "../../node_modules/circomlib-matrix/circuits/matElemSum.circom";

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component mul = matMul(n, n, 1);
    for (var i = 0; i < n; i++) {
        for (var j = 0; j < n; j++) {
            mul.a[i][j] <== A[i][j];
        }
        mul.b[i][0] <== x[i];
    }

    component diff = matSub(n, 1);
    for (var i = 0; i < n; i++) {
        diff.a[i][0] <== mul.out[i][0];
        diff.b[i][0] <== b[i];
    }

    component diffDotProd = matElemMul(n, 1);
    for (var i = 0; i < n; i++) {
        diffDotProd.a[i][0] <== diff.out[i][0];
        diffDotProd.b[i][0] <== diff.out[i][0];
    }

    component mag2 = matElemSum(n, 1);
    for (var i = 0; i < n; i++) {
        mag2.a[i][0] <== diffDotProd.out[i][0];
    }

    component isSolution = IsZero();
    isSolution.in <== mag2.out;

    out <== isSolution.out;
}

component main {public [A, b]} = SystemOfEquations(3);