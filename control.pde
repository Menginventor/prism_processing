void keyboard_control1 (robot R) {
  float x = 0, y = 0, h  = 0;
  if (is_key_pressed('W'))x++;
  if (is_key_pressed('S'))x--;
  if (is_key_pressed('A'))y++;
  if (is_key_pressed('D'))y--;
  if (is_key_pressed('Q'))h++;
  if (is_key_pressed('E'))h--;
  if (dist(0, 0, x, y)>0.0) {
    x = x/dist(0, 0, x, y);
    y = y/dist(0, 0, x, y);
  }
  
  R.reletive_state_dot[0][0] += 0.1*(1.5*x-R.reletive_state_dot[0][0]);
  R.reletive_state_dot[1][0] += 0.1*(1.5*y-R.reletive_state_dot[1][0]);
  R.reletive_state_dot[2][0] += 0.1*((PI/100)*h-R.reletive_state_dot[2][0]);
}
void keyboard_control2 (robot R) {
  float x = 0, y = 0, h  = 0;
  if (is_key_pressed('h'))x++;
  if (is_key_pressed('b'))x--;
  if (is_key_pressed('d'))y++;
  if (is_key_pressed('f'))y--;
  if (is_key_pressed('g'))h++;
  if (is_key_pressed('i'))h--;
  if (dist(0, 0, x, y)>0.0) {
    x = x/dist(0, 0, x, y);
    y = y/dist(0, 0, x, y);
  }
  
  R.reletive_state_dot[0][0] += 0.1*(1.5*x-R.reletive_state_dot[0][0]);
  R.reletive_state_dot[1][0] += 0.1*(1.5*y-R.reletive_state_dot[1][0]);
  R.reletive_state_dot[2][0] += 0.1*((PI/100)*h-R.reletive_state_dot[2][0]);
}