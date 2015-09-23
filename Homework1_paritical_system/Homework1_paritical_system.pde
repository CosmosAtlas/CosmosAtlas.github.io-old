import damkjer.ocd.*;
import java.util.ArrayList;


int genRate = 10000;
int timer;
float particleLifeSpan = 1.7f;
float smokeSpanTime = 1.7f;
float rotx = 0;
float roty = 0;

ArrayList<PVector> particlePos = new ArrayList<PVector>();
ArrayList<Float> particleSpan = new ArrayList<Float>();
ArrayList<PVector> particleSpeed = new ArrayList<PVector>();

ArrayList<PVector> smokePar = new ArrayList<PVector>();
ArrayList<Float> smokeSpan = new ArrayList<Float>();
ArrayList<PVector> smokeSpeed = new ArrayList<PVector>();

PVector cameraPos;
PVector cameraView;


void setup()
{
	size(1280, 1024, P3D);
	noStroke();
	smooth();
 cameraPos = new PVector(0, -height/2, -(height/2.0) / tan(PI*30.0 / 180.0));
 cameraView = new PVector(0, height/2, (height/2.0) / tan(PI*30.0 / 180.0));
	timer = millis();
	camera(cameraPos.x, cameraPos.y, cameraPos.z,
			cameraPos.x + cameraView.x, cameraPos.y + cameraView.y, cameraPos.z + cameraView.z,
			0,1,0);
}

void drawBase()
{
	pushMatrix();
	translate(0,500,0);
	fill(80);
	noStroke();
	box(1000);
	popMatrix();
}

void generateParticles(float dt)
{
	dt/=1000;
	float num_particles = dt*genRate;
	float fracPart = num_particles - (int)(num_particles);
	num_particles = (int)(num_particles);
	if (random(100) <= fracPart * 100)
	{
		num_particles += 1;
	}
	float xPos;
	float zPos;
	int radius = 100;
	for(int i = 0; i < num_particles; i++)
	{
		xPos = random(-radius,radius);
		zPos = random(-radius,radius);
		while (xPos*xPos + zPos*zPos > radius*radius)
		{
			xPos = random(-radius,radius);
			zPos = random(-radius,radius);
		}
		particlePos.add(new PVector(xPos,0,zPos));
		particleSpan.add(particleLifeSpan);
		particleSpeed.add(new PVector(random(-300,300), random(300,450), random(-300,300)));
	}
}

void drawParticles(float dt)
{
	dt/=1000;
	PVector speed = new PVector(0,0,0);
	for(int i = 0; i < particlePos.size(); i ++)
	{
    stroke(255, 255*particleSpan.get(i)/particleLifeSpan,0);
    point(particlePos.get(i).x,-particlePos.get(i).y,particlePos.get(i).z);

		//pushMatrix();
		//translate(particlePos.get(i).x, - particlePos.get(i).y, particlePos.get(i).z);
		//fill(255, 255*particleSpan.get(i)/particleLifeSpan,0, 255*(particleSpan.get(i)/particleLifeSpan));
		////sphere(5);
		//ellipseMode(CENTER);
		//ellipse(0,0,10,10);  
		//popMatrix();

		speed.x = particleSpeed.get(i).x;
		speed.y = particleSpeed.get(i).y;
		speed.z = particleSpeed.get(i).z;
		particleSpan.set(i, particleSpan.get(i)-dt);
		//System.out.println(speed.x + " " + speed.y + " " + speed.z);
		particlePos.set(i, particlePos.get(i).add(speed.mult(dt)));
		particleSpeed.set(i, new PVector(particleSpeed.get(i).x - particlePos.get(i).x * 0.1, particleSpeed.get(i).y, particleSpeed.get(i).z - particlePos.get(i).z * 0.1));

	}
	for(int i = 0; i < particlePos.size(); i ++)
	{
		if (particleSpan.get(i) <= 0)
		{
			removeParticle(i);
		}
	}
}

void removeParticle(int i)
{
	smokePar.add(particlePos.get(i));
	smokeSpan.add(smokeSpanTime);
	smokeSpeed.add(particleSpeed.get(i));

	particlePos.remove(i);
	particleSpan.remove(i);
	particleSpeed.remove(i);
}

void drawSmoke(float dt)
{
	dt /= 1000;
	stroke(255);
	PVector speed = new PVector(0,0,0);
	for(int i = 0; i < smokePar.size(); i++)
	{
		point(smokePar.get(i).x, -smokePar.get(i).y, smokePar.get(i).z);
          //pushMatrix();
          //translate(smokePar.get(i).x, - smokePar.get(i).y, smokePar.get(i).z);
          //fill(255, 255*(smokeSpan.get(i)/smokeSpanTime));
          //noStroke();
          ////sphere(5);
          //ellipseMode(CENTER);
          //ellipse(0,0,10,10);  
          //popMatrix();
		speed.x = smokeSpeed.get(i).x;
		speed.y = smokeSpeed.get(i).y;
		speed.z = smokeSpeed.get(i).z;
		smokeSpan.set(i, smokeSpan.get(i)-dt);
		smokePar.set(i, smokePar.get(i).add(speed.mult(dt)));
		smokeSpeed.set(i, new PVector(smokeSpeed.get(i).x - smokePar.get(i).x * 0.1, smokeSpeed.get(i).y, smokeSpeed.get(i).z - smokePar.get(i).z * 0.1));

	}


	for(int i = 0; i < smokePar.size(); i++)
	{
		if (smokeSpan.get(i) < 0)
		{
			removeSmoke(i);
		}
	}
}

void removeSmoke(int i)
{
	smokePar.remove(i);
	smokeSpan.remove(i);
	smokeSpeed.remove(i);
}

void draw()
{
  background(0);
	lights();
  updateCamera();
  
  camera(cameraPos.x, cameraPos.y, cameraPos.z,
          cameraPos.x + cameraView.x, cameraPos.y + cameraView.y, cameraPos.z + cameraView.z,
        0,1,0);
	drawBase();
	generateParticles(1000/frameRate);
	drawParticles(1000/frameRate);
	drawSmoke(1000/frameRate);
	System.out.println(frameRate);
	timer=millis();
}

void updateCamera()
{
  if (keyPressed == true)
  {
    if (key == 'w')
    {
      cameraPos.z += 10;
    }
    if (key == 's')
    {
      cameraPos.z -= 10;
    }
    if (key == 'a')
    {
      cameraPos.x += 10;
    }
    if (key == 'd')
    {
      cameraPos.x -= 10;
    }
    if (key == CODED)
    {
      if (keyCode == LEFT)
      {
        cameraView.x += 10;
      }
      if (keyCode == RIGHT)
      {
        cameraView.x -= 10;
      }
      if (keyCode == UP)
      {
        cameraView.y -=10;
      }
      if (keyCode == DOWN)
      {
        cameraView.y += 10;
      }
    }
  }
}