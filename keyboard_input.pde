String keycode_pressed = "";
void keyPressed() {
  char _key = char(keyCode);
  if (keycode_pressed.indexOf(_key) == -1) {
    keycode_pressed += _key;
     //println(str(int(char(keyCode)))+" , "+keycode_pressed);
  }

  if (int(char(keyCode)) == 32) {//space bar
   if(data_reg[power_addr] == 0)data_reg[power_addr] = 1;
   else data_reg[power_addr] = 0;
  }
  
  if (int(char(keyCode)) == 10) {//enter
  
  }
  
}
void keyReleased() {
  keycode_pressed = join(split(keycode_pressed, char(keyCode)), "");
  //println(keycode_pressed);
}

boolean is_key_pressed(char _key) {//Upper case in keyboard layout
  if (keycode_pressed.indexOf(_key) != -1)return true;
  return false;
}