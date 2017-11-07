import processing.serial.*;
Serial myPort;
/*const*/
byte power_addr = 0;
byte crr_pos_addr = 1;
byte crr_x_addr = 1;
byte crr_y_addr = 5;
byte crr_h_addr = 9;

byte goal_pos_addr = 13;
byte goal_x_addr = 13;
byte goal_y_addr = 17;
byte goal_h_addr = 21;

byte p_addr = 25;
byte p1_addr = 25;
byte p2_addr = 29;
byte p3_addr = 33;
/*const*/
boolean receiving = false;

boolean requesting = false;

boolean sending = false;

boolean success_trancieve = false;

byte requesting_addr = 0;
byte requesting_len = 0;
long serial_rx_time = millis();

String serial_port_name = "COM5";
int serial_baud = 115200;
long serial_time_char = (10L*1000000000L)/115200L;
byte [] serial_buffer = new byte [64];
int serial_buffer_index = 0;
byte pack_len = 0;
byte check_sum = 0;
byte [] data_reg = new byte [64];
int data_request_time = millis();

byte power_state = byte(1);

void serial_connect(String port_name) {
  myPort = new Serial(this, port_name, serial_baud);
}


void serialEvent(Serial p) {

  serial_timeout_check();
  
  byte inChar = byte(p.read()); 
  if(!sending ){
    println("error, we got unexpect data!");
    return;
  }
  if (!receiving) {
    serial_buffer_index = 0;
    check_sum = 0;
    if (inChar == byte(0xFF)) {
      receiving = true;
    } else {
      return;
    }
  }

  if (serial_buffer_index ==1 && inChar != byte(0xFF)) {
    receiving = false;
    return;
  }



  if (serial_buffer_index == 2 ) {
    pack_len = inChar;
  }
  if (serial_buffer_index >= 2 &&  serial_buffer_index < pack_len + 2) {
    check_sum += inChar;
  } else if (serial_buffer_index == pack_len + 2) {
    serial_buffer[serial_buffer_index] = inChar;
    serial_buffer_index++;
    receiving = false;
    pack_end();

    return;
  }


  serial_buffer[serial_buffer_index] = inChar;
  serial_buffer_index++;
  serial_rx_time = millis();
}


void serial_timeout_check() {
  if (millis() - serial_rx_time > 100 &&(receiving)) {
    receiving = false;
    sending = false;
    //pack_end();

    //println(b2f(serial_buffer));
  }
  if(millis()-data_request_time>100 &&requesting){
    requesting = false;
  }
   if(millis()-sending_timeout_timer>100 &&sending){
    sending = false;
  }
}




byte[] make_packet (byte instruction, byte addr, byte [] data) {
  byte [] result = new byte[6+data.length];//packet size = 2(header)+1(length)+1(instruction)+1(checksum)+data size
  result[0] = byte(0xFF);
  result[1] = byte(0xFF);
  byte len = byte(data.length + 3);
  result[2] = len;
  result[3] = instruction;
  result[4] = addr;
  byte checksum  = 0;
  checksum += len;
  checksum += instruction;
  checksum += addr;
  for (int i = 0; i<data.length; i++) {
    result[i+5] = data[i];
    checksum += data[i];
  }

  checksum = byte (~checksum);
  result[5+data.length] = checksum ;

  return result;
}

void send_packet (byte[] data) {
  begin_sending();
  for (int i = 0; i<data.length; i++) {
    myPort.write(data[i]);
  }
}
byte checksum (byte[] data) {
  byte result = 0;

  for (int i = 0; i<data.length; i++) {
    result += data[i];
  }
  result = byte (~result);
  return result;
}

float b2f (byte[] inData) {
  int intbit = 0;

  intbit = (inData[3] << 24) | ((inData[2] & 0xff) << 16) | ((inData[1] & 0xff) << 8) | (inData[0] & 0xff);

  float f = Float.intBitsToFloat(intbit);
  //println(f);
  return f;
}
byte[] f2b (float a) {
  int intbit = Float.floatToIntBits(a);
  byte[] b = {byte(intbit & 0xff), byte((intbit>>8) & 0xff), byte((intbit>>16) & 0xff), byte((intbit>>24) & 0xff)};
  return b;
}

void data_request(byte addr, byte len) {// read instruction = 0x02
  requesting_addr = addr;
  requesting_len = len;
  requesting = true;
  byte [] data ;
  byte [] l_len = {len};
  data = make_packet(byte(0x02), addr, l_len);//make_packet (byte instruction, byte addr, byte [] data) {

  print_time_stamp();
  println("requesting "+str(data.length)+" byte");
  for (int i = 0; i<data.length; i++) {
    print(hex(data[i], 2) + ' ');
  }
  println( );
  send_packet(data);
  data_request_time = millis();
}
void data_write(byte addr, byte[] data_w) {// write instruction = 0x03
  byte [] data ;

  data = make_packet(byte(0x03), addr, data_w);//make_packet (byte instruction, byte addr, byte [] data) {

  print_time_stamp();
  println("sending "+str(data.length)+" byte");
  for (int i = 0; i<data.length; i++) {
    print(hex(data[i], 2)+' ');
  }
  println( );
  send_packet(data);
}