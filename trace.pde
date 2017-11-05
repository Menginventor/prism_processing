
class trace {
  PGraphics trace;
  boolean first_trace = true;
  float [][] trace_pos = {{0}, {0}}; 
  color line_color;
  trace(color C){
    line_color = C;
  }
  void init(){
    trace = createGraphics(width, height);
  }
  void update(float[][]state) {
    float [][] pos = {{state[0][0]}, {state[1][0]}};
    pos = invert_canvas_tranform(pos);
    if (first_trace) {
      trace_pos [0][0] = get_x(pos);
      trace_pos [1][0] = get_y(pos);
      first_trace = false;
      return;
    } else {
      trace.beginDraw();
      trace.stroke(line_color);

      trace.line(get_x(trace_pos), get_y(trace_pos), get_x(pos), get_y(pos));
      trace_pos [0][0] = get_x(pos);
      trace_pos [1][0] = get_y(pos);
      trace.endDraw();
    }
  }
  void draw() {
    image(trace,get_x(canvas_translate), get_y(canvas_translate));
  }
}