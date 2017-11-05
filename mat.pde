float[][] mat_add (float[][] A, float[][] B) {
  /*
  : Example
   float[][] A = {{1, 2,3}, {4,5,6}};
   float[][] B = {{1, 2,3}, {4,5,6}};
   println("mat A");
   mat_print(A);
   println("mat B");
   mat_print(B);
   println("mat A+B");
   mat_print(mat_add(A,B));
   */
  float [][] result = new float [A.length][A[0].length];
  for (int i = 0; i<result.length; i++) {

    for (int j = 0; j<result[0].length; j++) {
      result[i][j] = A[i][j]+B[i][j];
    }
  }
  return result;
}
float[][] mat_add4 (float[][] A, float[][] B, float[][] C, float[][] D) {

  float [][] result = new float [A.length][A[0].length];
  for (int i = 0; i<result.length; i++) {

    for (int j = 0; j<result[0].length; j++) {
      result[i][j] = A[i][j]+B[i][j]+C[i][j]+D[i][j];
    }
  }
  return result;
}
float[][] mat_scale (float A, float[][] B) {
  /*
  : Example
   float     A = 3.0;
   float[][] B = {{1, 2,3}, {4,5,6}};
   println("A");
   println(A);
   println("mat B");
   mat_print(B);
   println("mat A*B");
   mat_print(mat_scale(A,B));
   */
  float [][] result = new float [B.length][B[0].length];
  for (int i = 0; i<result.length; i++) {

    for (int j = 0; j<result[0].length; j++) {
      result[i][j] = A*B[i][j];
    }
  }
  return result;
}

float[][] mat_mul (float[][] A, float[][] B) {
  /*
  : Example
   float[][] A = {{1,2},{-1,0},{3,2}};
   float[][] B = {{1, 5, 2}, {-2, 0, 1}};
   println("A");
   mat_print(A);
   println("mat B");
   mat_print(B);
   println("mat A*B");
   mat_print(mat_mul(A, B));
   */
  if (A[0].length != B.length) {
    println("mat_mul error");
  }
  float [][] result = new float [A.length][B[0].length];
  for (int i = 0; i<result.length; i++) {

    for (int j = 0; j<result[0].length; j++) {
      result[i][j] = 0;
      for (int k = 0; k<A[0].length; k++) {
        result[i][j] += A[i][k]*B[k][j];
      }
    }
  }
  return result;
}

void mat_print(float[][] A) {
  if (A[0].length == 0 || A.length == 0) {
    println("<Blank matrix>");
  } else {
    println("row = "+str(A.length)+","+"col = "+str(A[0].length));
    for (int i = 0; i<A.length; i++) {
      print("[\t");
      for (int j = 0; j<A[0].length; j++) {
        print(A[i][j]);
        print('\t');
      }
      println("\t]");
    }
  }
}

float get_x(float [][]X) {
  return X[0][0];
}
float get_y(float [][]X) {
  return X[1][0];
}
float get_h(float [][]X) {
  return X[2][0];
}

float [][] mat_R2 (float theta) {
  float _cos = cos(theta);
  float _sin = sin(theta);
  float[][] R2 = {{_cos, -_sin}, {_sin, _cos}};
  return R2;
}
float [][] mat_RZ3 (float theta) {
  float _cos = cos(theta);
  float _sin = sin(theta);
  float[][] R3 = {{_cos, -_sin,0}, {_sin, _cos,0},{0,0,1}};
  return R3;
}

float  mat_det3 (float [][] M) {
  float  A = M[0][0];
  float  B = M[0][1];
  float  C = M[0][2];
  float  D = M[1][0];
  float  E = M[1][1];
  float  F = M[1][2];
  float  G = M[2][0];
  float  H = M[2][1];
  float  I = M[2][2];
  return A*E*I+B*F*G+C*D*H-C*E*G-B*D*I-A*F*H;
}
float  mat_det2 (float [][] M) {
  float  A = M[0][0];
  float  B = M[0][1];
  float  C = M[1][0];
  float  D = M[1][1];

  return A*D-C*B;
}
float [][] mat_tranpose(float[][] A) {
  float [][] R = new float[A[0].length][A.length];
  for (int i = 0; i<R.length; i++) {

    for (int j = 0; j<R[0].length; j++) {
      R[i][j] = A[j][i];
    }
  }

  return R;
}

float  mat_minor3 (float [][] A, int row, int col) {
  float [][] R = new float[2][2];
  for (int i = 0; i<A.length; i++) {
    int _i = i;
    if (i == row)continue;
    if (i > row)_i = i-1;
    for (int j = 0; j<A[0].length; j++) {
      int _j = j;
      if (j == col)continue;
      if (j > col)_j = j-1;
      R[_i][_j] = A[i][j];
    }
  }
  
  return  mat_det2(R);
}
float[][] mat_cofact3 (float [][] A) {
  float [][] R = new float[3][3];
  for (int i = 0; i<R.length; i++) {

    for (int j = 0; j<R[0].length; j++) {

      R[i][j] = pow(-1, i+j)* mat_minor3(A, i, j);
    }
  }
  return R;
}

float[][] mat_adj3 (float [][]A) {

  return  mat_tranpose(mat_cofact3(A));
}


float[][] mat_invert3(float [][]A){
  return mat_scale(1.0/mat_det3(A),mat_adj3(A));
}