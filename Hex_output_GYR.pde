PrintWriter output;
void setup()
{
  output=createWriter("myfile7.gcode");

  int centerX=0;
  int centerY=0;
  int rad1=30;
  float rad=0;
  float theta1=0;
  float x_old=0;
  float y_old=0;
  float extrude=0;
  float E_ratio=0.19/4;
  float z=0;
  float rad_max=0;
  float zmax=10;
  output.println("M83");
  for (z=0.2; z<zmax; z+=0.2)
  {
    output.println("G1 Z"+z);
    theta1=10+z*100/zmax; //profile curve of cone - dome whape with some offset
    rad_max=2+10*sin(radians(theta1)); //max center size
    println("z="+z+"theta="+theta1+" radmax="+rad_max);
    for  (rad=rad_max-1.5; rad<rad_max; rad+=0.4)
    {
      for (float theta2=0; theta2<360; theta2+=12)
      {
        float x_new=centerX+rad*cos(radians(theta2));
        float y_new=centerY+rad*sin(radians(theta2));
        float line_length=dist(x_new, y_new, x_old, y_old);
        extrude=line_length*E_ratio;
        output.println("G1 X"+x_new+" Y"+y_new+" F1000 E"+ extrude);
        x_old=x_new;
        y_old=y_new;
      }
    }
    
    //-------------- start outer circle ------------- 
    output.println("G0 F3000 E-3");
    x_old=centerX+rad1;
    y_old=centerY;
    output.println("G0 X"+x_old+" Y"+y_old+" F3000");
    output.println("G0 F3000 E3.1");
    for (float theta2=0; theta2<=360; theta2+=12)
    {
      float x_new=centerX+rad1*cos(radians(theta2));
      float y_new=centerY+rad1*sin(radians(theta2));
      float line_length=dist(x_new, y_new, x_old, y_old);
      extrude=line_length*E_ratio;
      output.println("G1 X"+x_new+" Y"+y_new+" F1000 E"+ extrude);
      x_old=x_new;
      y_old=y_new;
    }
    output.println("G0 F3000 E-3");
    x_old=centerX+rad;
    y_old=centerY;
    output.println("G0 X"+x_old+" Y"+y_old+" F3000");
    output.println("G0 F3000 E3.1");
  }
  //-------------- end of outer circle -------------
  
  
  // for (z=zmax+0.2; z<zmax+1; z+=0.2)
  // {
    
  // }



  output.flush();
  output.close();
}
