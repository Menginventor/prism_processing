class robot {
  /*state variable*/
  float [][]robot_g_state = {{0}, {0}, {-PI/2.0}};
  float [][]reletive_state_dot = {{0}, {0}, {0}};

  /*kinematic variable*/
  float frame_l = 1;
  float wheel_r = 1;

  float[][] j1f = {
    {sin(PI/3), -cos(PI/3), -frame_l}, 
    {0, -cos(PI), -frame_l}, 
    {sin(-PI/3), -cos(-PI/3), -frame_l}
  };
  float [][] inv_j1f = mat_invert3(j1f);

  color robot_color;
  robot(color C) {
    robot_color = C;
  }
  void draw() {
    float x = robot_g_state[0][0];
    float y = robot_g_state[1][0];
    float h = robot_g_state[2][0];

    float frame_r = 20;
    //for tri-angle

    float x1 = frame_r*cos(radians(60));
    float x2 = frame_r*cos(radians(-60));
    float x3 = frame_r*cos(radians(180));

    float y1 = frame_r*sin(radians(60));
    float y2 = frame_r*sin(radians(-60));
    float y3 = frame_r*sin(radians(180));

    float x0 = 0.0;
    float y0 = 0.0;
    float x4 = 20.0;
    float y4 = 0.0;

    float [][] robot_pos = {{x}, {y}};
    float [][][] robot_body = { {{x0}, {y0}}, {{x1}, {y1}}, {{x2}, {y2}}, {{x3}, {y3}}, {{x4}, {y4}}     };

    float [][][] tran_robot_body = {{{0}, {0}}, {{0}, {0}}, {{0}, {0}}, {{0}, {0}}, {{0}, {0}}  };
    for (int i = 0; i<robot_body.length; i++) {
      float [][] coord = {{robot_body[i][0][0]}, {robot_body[i][1][0]}};
      float [][] tran_coord = invert_canvas_tranform(mat_add(robot_pos, mat_mul(mat_R2(h), coord)));
      tran_robot_body[i][0][0] = tran_coord[0][0];
      tran_robot_body[i][1][0] = tran_coord[1][0];
    }
    stroke(robot_color);
    fill(robot_color, 127);
    triangle(get_x(tran_robot_body[1]), get_y(tran_robot_body[1]), get_x(tran_robot_body[2]), get_y(tran_robot_body[2]), 
      get_x(tran_robot_body[3]), get_y(tran_robot_body[3]));
    line(get_x(tran_robot_body[0]), get_y(tran_robot_body[0]), get_x(tran_robot_body[4]), get_y(tran_robot_body[4]));
  }
  void state_update() {
    robot_g_state = runge(robot_g_state, reletive_state_dot, 0.001);
  }


  float [][] omni_kinemetic (float[][] wheel_thata_dot) {
    float [][] result = new float [3][1];

    //result =   mat_mul(mat_mul(mat_tranpose(mat_RZ3(get_h(robot_g_state))), inv_j1f), mat_scale(wheel_r, wheel_thata_dot));
    result =   mat_mul(inv_j1f, mat_scale(wheel_r, wheel_thata_dot));
    //mat_print(result);
    return result;
  }
  void wheel_control(float[][] wheel_thata_dot){
    reletive_state_dot = omni_kinemetic(wheel_thata_dot);
  }
};