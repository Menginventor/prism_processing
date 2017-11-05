float [][] canvas_mat = {{1,0},{0,-1}};
float [][] invert_canvas_mat = {{1,0},{0,-1}};
float [][] canvas_translate = {{0},{0}};

float [][] canvas_tranform(float [][]X){
  float [][] center_mat = {{-width/2.0},{height/2.0}};
  return mat_add(mat_scale(-1.0,canvas_translate),mat_add(mat_mul(canvas_mat,X),center_mat));
  
}

float [][] invert_canvas_tranform(float [][]F){
  float [][] center_mat = {{-width/2.0},{height/2.0}};
  return mat_mul(invert_canvas_mat,mat_add(mat_scale(1.0,canvas_translate),mat_add(F,mat_scale(-1,center_mat)))   );
  
}