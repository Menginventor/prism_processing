int sending_timeout_timer = millis();
void begin_sending(){
  sending_timeout_timer = millis();
  sending = true;
}
void pack_end() {
 
  sending = false;
  check_sum = byte(~check_sum);
  /*
  print_time_stamp();
  println("Receiving "+serial_buffer_index+" byte");
  for (int i = 0; i<serial_buffer_index; i++) {
    print(hex(serial_buffer[i], 2)+' ');
  }
  println();
  */
  //println("check sum = "+hex(check_sum,2));
  if (check_sum != serial_buffer[serial_buffer_index-1]) {
    println("incoming packet's checksum error");
    return;
  }
  if (serial_buffer[3] != 0 && serial_buffer_index>2) {
    println("device report that sended command error ,code = "+str(serial_buffer[3]));
     requesting = false;
    return;
  }
  if (requesting) {
    
    //println("receive requested data at addr "+str(requesting_addr)+" ,len = "+str(requesting_len));
    for(int i = 0;i<requesting_len;i++){
      data_reg[i+requesting_addr] = serial_buffer[i+4];
    }
    //display_float_reg(requesting_addr,byte(requesting_len/4));
    requesting = false;
    // follower.state_update();
  }
}

void display_float_reg(byte addr, byte len){
  for(int i = 0;i<len;i++){
    println("float reg ["+str(i*4+addr)+"]  = "+str(b2f(subset(data_reg, i*4+addr,4))));
  }
  
}

void send_crr_pos(float [][] crr_pos){
  byte [] data_to_send = concat(f2b(crr_pos[0][0]), concat(f2b(crr_pos[1][0]), f2b(crr_pos[2][0])));
  data_write(byte(crr_pos_addr),data_to_send);//
}
void send_goal_pos(float [][] pos){
  byte [] data_to_send = concat(f2b(pos[0][0]/100.0), concat(f2b(pos[1][0]/100.0), f2b(pos[2][0])));
  data_write(byte(goal_pos_addr),data_to_send);//
}