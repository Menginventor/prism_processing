
robot Leader = new robot(color(0, 255, 0));
robot follower = new robot(color(255, 0, 0));
trace Leader_trace = new trace(color(0, 255, 0));
trace follower_trace = new trace(color(255, 0, 0));


void setup() {
  size(1000, 1000);
  Leader_trace.init();
  follower_trace.init();
  //noCursor();


  println(Serial.list());
  serial_connect(serial_port_name);
  frameRate(50);
  byte[] off = {0};
  byte[] on = {1};
}


void draw() {
  background(0);
  Leader_trace.draw() ;
  follower_trace.draw() ;

  Leader.draw();
  follower.draw();
  for (int i = 0; i < 2; i++) {
    Leader_trace.update(Leader.robot_g_state);
    follower_trace.update(follower.robot_g_state);
    Leader.state_update();
    follower.state_update();

    keyboard_control1 (Leader);

    //keyboard_control2 (follower);
    serial_timeout_check() ;
  }

  if (!requesting) {
    if (power_state != data_reg[0]) {
      data_reg[0] = power_state;
      byte[] _power = {data_reg[0]};
      data_write (byte(0),_power);
    } else {
      send_crr_pos (follower.robot_g_state);
      delay(2);
      send_goal_pos (Leader.robot_g_state); 
      delay(2);
      data_request(byte(p_addr), byte(12));
      delay(2);
      float [][] wheel_speed = {{b2f(subset(data_reg, 25, 4))}, {b2f(subset(data_reg, 29, 4))}, {b2f(subset(data_reg, 33, 4))}};
      follower.wheel_control(wheel_speed);
    }
  } else if (millis()-data_request_time>500) {
    data_request_time = millis();
    println("device not responding");
    send_crr_pos (follower.robot_g_state);
    delay(2);
    send_goal_pos (Leader.robot_g_state); 
    delay(2);
    data_request(byte(p_addr), byte(12));
    delay(2);
  }

  draw_cursor();
}