PrintWriter output;
void setup()
{
  output=createWriter("myfile9.gcode");

  int centerX=80;
  int centerY=80;
  int rad1=30;
  float rad=0;
  float theta1=0;
  float x_old=centerX;
  float y_old=centerY;
  float extrude=0;
  float E_ratio=0.19/4*0.75;
  float z=0;
  float rad_max=0;
  float zmax=10;
  float twist_offset=0;
  int number_of_leaves=5;
  int i=0;
  output.println("M83");
  output.println("G1 Z"+z);
  output.println("G0 X"+centerX+" Y"+centerY+" F5000");
  for (z=0.2; z<zmax; z+=0.2)
  {
    output.println("G1 Z"+z);
    theta1=15+z*110/zmax; //profile curve of cone - dome whape with some offset
    rad_max=4+8*sin(radians(theta1)); //max center size
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

  float z_curr=zmax+0.2;
  for (z=zmax+0.2; z<zmax+2.5; z+=0.15)
  {
    output.println("G1 Z"+z);
    boolean leaf = true;
    theta1=twist_offset;
    float section_angle=360/number_of_leaves;
    float leaf_angle=2;
    float rad_leaf=rad1-0.15; //minimum overlap avoid sticking
    float rad_noleaf=rad_max-1.2; //sufficient overlap
    while (theta1<=360+twist_offset)
    {
      if (leaf)
      {
        theta1+=leaf_angle;
        rad=rad_leaf;
        z_curr=zmax+0.2;
      } else
      {
        theta1+=section_angle-leaf_angle;
        rad=rad_noleaf;
        z_curr=z;
      }

      leaf=!leaf;

      float x_new=centerX+rad*cos(radians(theta1));
      float y_new=centerY+rad*sin(radians(theta1));
      float line_length=dist(x_new, y_new, x_old, y_old);
      extrude=line_length*E_ratio;
      output.println("G1 X"+x_new+" Y"+y_new+" Z"+z_curr+" F1000 E"+ extrude);
      x_old=x_new;
      y_old=y_new;
    }
    twist_offset+=3;
  }



  output.flush();
  output.close();
}
