float [][] global_state_dot (float [][] g_state, float [][] reletive_state_dot) {
  //stateformat {{x},{y},{h}}
  //pos format  {{x},{y}}
  float [][] r_pos_dot = {{reletive_state_dot[0][0]}, {reletive_state_dot[1][0]}};
  float [][] g_pos_dot =  mat_mul(mat_R2(g_state[2][0]), r_pos_dot);
  float [][] result = {{g_pos_dot[0][0]}, {g_pos_dot[1][0]}, {reletive_state_dot[2][0]}};

  return result;
}

float [][] runge(float [][] g_state, float [][] r_state_dot, float h) {
  float [][] result = new float [g_state.length][g_state[0].length];
  float [][] K1 = global_state_dot(g_state,  r_state_dot);
  float [][] K2 = global_state_dot(mat_add(g_state, mat_scale(0.5*h, K1)),  r_state_dot);
  float [][] K3 = global_state_dot(mat_add(g_state, mat_scale(0.5*h, K2)),  r_state_dot);
  float [][] K4 = global_state_dot(mat_add(g_state, mat_scale(h, K3)),  r_state_dot);

  result = mat_add(   g_state, mat_scale( 1.0/4.0, mat_add(mat_add(  K1, mat_scale(2, K2)), mat_add(mat_scale(2, K3), K4))   )   );

  return result;
}