/*
Physical syn.
*/
robot Leader = new robot(color(0, 255, 0));
robot follower = new robot(color(255, 0, 0));
trace Leader_trace = new trace(color(0, 255, 0));
trace follower_trace = new trace(color(255, 0, 0));

int com_state = 0;
int request_timer = millis();
void setup() {
  size(1000, 1000);
  Leader_trace.init();
  follower_trace.init();
  //noCursor();


  println(Serial.list());
  serial_connect(serial_port_name);
  frameRate(50);

  data_reg[power_addr] = 1;
  /*
  Leader.reletive_state_dot[0][0] = 2;
  Leader.reletive_state_dot[1][0] = 0;
  Leader.reletive_state_dot[2][0] = 0.01;
  */
}


void draw() {
  background(0);
  Leader_trace.draw() ;
  follower_trace.draw() ;

  Leader.draw();
  follower.draw();
  //for (int i = 0; i < 2; i++) {
  Leader_trace.update(Leader.robot_g_state);
  follower_trace.update(follower.robot_g_state);
  Leader.state_update();
  follower.state_update();

  keyboard_control1 (Leader);

  //keyboard_control2 (follower);
  serial_timeout_check() ;
  //}

  /*
    if (power_state != data_reg[0] && !sending) {
   sending = true;
   data_reg[0] = power_state;
   byte[] _power = {data_reg[0]};
   data_write (byte(0),_power);
   } else {
   */

  if (!sending && !requesting &&millis()-request_timer>=10 ) {
    request_timer = millis();
    //println(com_state);
    if(com_state > 3)com_state = 0;
    if (com_state  == 0) {

      byte[] _power = {data_reg[power_addr]};
      data_write (byte(0), _power);
   
     
      
    } else if (com_state  == 1) {
       send_goal_pos (Leader.robot_g_state); 
      
    
      
    } else if (com_state  == 2) {
      data_request(byte(crr_pos_addr), byte(12));
   
     
    } else if (com_state  == 3) {
       if (!requesting) {
        float crr_x = b2f(subset(data_reg, crr_x_addr, 4));
        float crr_y = b2f(subset(data_reg, crr_y_addr, 4));
        float crr_h = b2f(subset(data_reg, crr_h_addr, 4));
        
        float [][] crr_state = {{crr_x *100}, {crr_y*100}, {crr_h}};
        follower.robot_g_state = crr_state;
        
        
       
      }
      
      
    } 
    com_state++;
  } else {
    //println(str(sending)+" , "+str(requesting)+" , "+str(receiving));
  }
  //}


  draw_cursor();
}