import java.util.ArrayList;

ArrayList<PVector> pos = new ArrayList<PVector>();
ArrayList<Float> span = new ArrayList<Float>();
ArrayList<PVector> v = new ArrayList<PVector>();


float particleLifeSpan = 1.7f;
int genRate = 3000;

float ground = 0.0; // ground is always parallel to ZOX plane, format: y = ground
float gravity = 1500;

// camera variables
float cx = 0.0;
float cy = -300.0;
float cz = 600.0;

// mouse click variables
float clickedX; 
float clickedY;
float rotx = 0;
float roty = 0;
float tx = 0.0;
float ty = 0.0;
float s = 1.0;


void setup() {
  size(800, 600, P3D);
  lights();
  noStroke();
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  
  // initilization
  
  
  
  
}

void draw() {
  background(0);
  camera(cx, cy, cz,
        0.0, 0.0, 0.0, 
        0.0, 1.0, 0.0);
  translate(tx, ty);
  rotateX(rotx);
  rotateY(roty);
  scale(s);
  drawScene();
  genParticles(1000/frameRate);
  drawParticles(1000/frameRate);
}

void genParticles(float dt)
{
  dt/=1000;
  float num_particles = dt * genRate;
  float fracPart = num_particles - (int)(num_particles);
  num_particles = (int)(num_particles);
  if (random(100) <= fracPart * 100)
  {
    num_particles += 1;
  }
  float xPos;
  float zPos;
  int r = 50;
  for(int i = 0; i < num_particles; i++)
  {
    xPos = random(-r,r);
    zPos = random(-r,r);
    while (xPos*xPos + zPos*zPos > r * r)
    {
      xPos = random(-r,r);
      zPos = random(-r,r);
    }
    pos.add(new PVector(xPos, 0, zPos));
    span.add(particleLifeSpan);
    v.add(new PVector(random(-300,300), random(-1200,-800), random(-300,300)));
  }
}

void removeParticle(int i)
{
  // remove particle when it hits the ground
  pos.remove(i);
  span.remove(i);
  v.remove(i);
}

boolean isDropToGound(int i)
{
  boolean isHit = false;
  if (pos.get(i).y >= ground) // left hand coordinate, so is >=
  {
    isHit = true;  
  }
  
  return isHit;
}


//----- draw helper function ---------
void drawScene(){
  pushMatrix();
  fill(204);
  translate(0, 1 + ground, 0);
  box(1000, 1, 1000);
  popMatrix();
}

void drawParticles(float dt)
{
  dt /= 1000;
  PVector speed = new PVector(0, 0, 0);
  for (int i = 0; i < pos.size(); i++)
  {
    speed.x = v.get(i).x;
    speed.y = v.get(i).y;
    speed.z = v.get(i).z;
    
    // draw particle circle
    pushMatrix();
    translate(pos.get(i).x, pos.get(i).y, pos.get(i).z);
    fill(64, 164, 223, random(0, 255));
    //ellipseMode(CENTER);
    //ellipse(0,0,random(1, 10), random(1, 10));
    sphereDetail(6, 6);
    sphere(random(1, 8));
    
    
    popMatrix();
    
    // update particle life span
    // span.set(i, span.get(i)-dt);
    //System.out.println(speed.x + " " + speed.y + " " + speed.z);
    
    // update particle position
    pos.set(i, pos.get(i).add(speed.mult(dt)));  // ds = dv * dt
    
    // update particle speed
    if (!isDropToGound(i)){
      // not at ground
      v.set(i, new PVector(v.get(i).x, v.get(i).y + gravity * dt , v.get(i).z)); //<>//
  }else {
      // drop to ground
      removeParticle(i);
    }
  
  }
}

//----- mouse and key board function
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
  if (e < 0.0) {
    s *= 1.2;
  }
  else if (e > 0.0) {
    s *= 0.8;
  }
}