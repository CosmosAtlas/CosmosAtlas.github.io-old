float g = 0.1;
float bounce_factor = -.7;
Ball ball = new Ball(20.0, 0.0, 0.0,  20.0);
Environment env = new Environment(0, 0, 0, 600, 400, 400);

// camera variables
float cx = 0.0;
float cy = 0.0;
float cz = 600.0;

// mouse click variables
float clickedX; 
float clickedY;
float rotx = 0;
float roty = 0;
float tx = 0.0;
float ty = 0.0;
float s = 1.0;


void setup()
{
  size(800, 600, P3D);
  smooth();
  lights();
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
}

void draw(){
  background(0);
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  translate(tx, ty);
  rotateX(rotx);
  rotateY(roty);
  scale(s);
  //translate(tx, ty, tz);
  env.show();
  ball.move();
  ball.show();
}

class Environment {
  float x;
  float y;
  float z;
  float w;
  float l;
  float h;
  
  Environment (float pos_x, float pos_y, float pos_z, float Width, float Height, float Length) {
    x = pos_x;
    y = pos_y;
    z = pos_z;
    w = Width;
    l = Length;
    h = Height;
  }
  
  void show() {
    noFill();
    pushMatrix();
    stroke(255);
    translate(x, y, z);
    box(w, h, l);
    popMatrix();
  }
  
  //---------------accessor--------------
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float getZ() {
    return z;
  }
  
  float getWidth() {
    return w;
  }
  
  float getLength() {
    return l;
  }
  
  float getHeight() {
    return h;
  }
  
}


class Ball {
  float x, y, z;
  float r;
  float vx = -3;
  float vy = 0;
  float vz = 2;
  
  Ball(float pos_x, float pos_y, float pos_z, float radius) {
    x = pos_x;
    y = pos_y;
    z = pos_z;
    r = radius;
  }
  
  void accelerate() {
    vy += g;
  }
  
  void detect_bounce () {
    float envX = env.getX();
    float envY = env.getY();
    float envZ = env.getZ();
    float envHalfW = env.getWidth()/2;
    float envHalfH = env.getHeight()/2;
    float envHalfL = env.getLength()/2;
    
    if (x + r > envX + envHalfW) {
      x = envX + envHalfW - r;
      vx *= bounce_factor;
    }
    if (x - r < envX - envHalfW) {
      x = r + envX - envHalfW;
      vx *= bounce_factor;
    }
    if (y + r > envY + envHalfH) {
      y = envY + envHalfH - r;
      vy *= bounce_factor;
    }
    if (y - r < envX - envHalfH) {
      y = r + envY - envHalfH;
      vy *= bounce_factor;
    }
    if (z + r > envZ + envHalfL) {
      z = envZ + envHalfL - r;
      vz *= bounce_factor;
    }
    if (z - r < envZ - envHalfL) {
      z = r + envZ - envHalfL;
      vz *= bounce_factor;
    }
  }
  
  void move() {
    accelerate();
    x += vx;
    y += vy;
    z += vz;
    
    detect_bounce();
  }
  
  void show() {
    //ellipse(x, y, 2*r, 2*r);
    lights();
    noStroke();
    pushMatrix();
    fill(255, 255, 0);
    translate(x, y, z);
    sphere(r);
    popMatrix();
  }
  
  //---------------accessor----------------
  float getVx() {
    return vx;
  }
  
  float getVy() {
    return vx;
  }
  
  float getVz() {
    return vz;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  float getZ() {
    return z;
  }
  
  float getR() {
    return r;
  }
  
}

//----- mouse and key board function
void keyPressed() {
  switch(key){
    case 'w':
    case UP:
      ty += 10;
      print(ty);
      break;
    case DOWN:
    case 's':
      break;
      
    case 'a':
    case LEFT:
      break;
    case 'd':
    case RIGHT:
      
      break;
  }
}

void mouseDragged() {
  float rate = 0.01;
  if (mouseButton == LEFT){
    rotx += (pmouseY-mouseY) * rate;
    roty += (mouseX-pmouseX) * rate;
  }
  
  if (mouseButton == RIGHT) {
    tx += mouseX - pmouseX;
    ty -= pmouseY - mouseY;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getAmount();
  print(e+"\n");
  if (e < 0.0) {
    s *= 1.2;
  }
  else if (e > 0.0) {
    s *= 0.8;
  }
}