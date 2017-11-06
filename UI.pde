void print_time_stamp(){
  //print("["+str(hour())+":"+str(minute())+":"+str(second())+":"+str(millis()%1000)+"] ");
  int millisec = millis();
  int second = (millisec/1000)%60;
  int minute = (millisec/1000/60)%60;
  int hour = (millisec/1000/60/60);
  print("["+str(hour)+":"+str(minute)+":"+str(second)+":"+str(millisec%1000)+"] ");
}
void draw_cursor() {
  float [][] mouse_mat = {{mouseX},{mouseY}};
  float [][] pos_mat = canvas_tranform(mouse_mat);
  float [][] frame_mat =invert_canvas_tranform(pos_mat );
  textSize(18);
  String coord_str = str(pos_mat[0][0])+","+str(pos_mat[1][0]);
  //println(coord_str);
  float coord_str_width = textWidth(coord_str);
  strokeWeight(1);
  stroke(0, 255, 0);
  line(0, get_y(frame_mat), width, get_y(frame_mat));
  line(get_x(frame_mat), 0, get_x(frame_mat), height);
  fill(0, 255, 0);
  rect(width-coord_str_width-20, height-10-18, coord_str_width+20, 28);
  fill(0, 0, 0);
  text(coord_str, width-coord_str_width-10, height-10);
   int millisec = millis();
  int second = (millisec/1000)%60;
  int minute = (millisec/1000/60)%60;
  int hour = (millisec/1000/60/60);
  String time = "runtime ["+str(hour)+":"+str(minute)+":"+str(second)+":"+str(millisec%1000)+"] ";
  float time_str_width = textWidth(time);
  fill(0, 255, 0);
  rect(0, height-10-18, time_str_width+20, 28);
  fill(0, 0, 0);
   text(time , 10, height-10);
}