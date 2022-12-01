PrintWriter output;
void setup()
{
  output=createWriter("myfile6.gcode");

  int centerX=0;
  int centerY=0;
  int rad1=3;
  float rad=1;
  float theta1=0;
  float x_old=0;
  float y_old=0;
  float extrude=0;
  float E_ratio=0.19/4;
  float z=0;
  float rad_max=2;
  float zmax=5;
  for (z=0.2; z<zmax; z+=0.2)
  {
    output.println("G1 Z"+z);
    theta1=z*90/zmax;
    rad_max=5*sin(radians(theta1));
    println("z="+z+"theta="+theta1+" radmax="+rad_max);
    for  (rad=rad_max-1.5; rad<rad_max; rad+=0.4)
    {
      for (float theta2=0; theta2<360; theta2+=12)
      {
        float x_new=centerX+rad*cos(radians(theta2));
        float y_new=centerY+rad*sin(radians(theta2));
        float line_length=dist(x_new, y_new, x_old, y_old);
        extrude+=line_length*E_ratio;
        output.println("G1 X"+x_new+" Y"+y_new+" F1000 E"+ extrude);
        x_old=x_new;
        y_old=y_new;
      }
    }
  }
  output.flush();
  output.close();
}
