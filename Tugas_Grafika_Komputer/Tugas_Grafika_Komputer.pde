import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import java.util.ArrayList;

PeasyCam cam;
PImage sunTexture;
PImage[] textures = new PImage[3];  // Adjusted to fit available textures
ArrayList<Planet> planets = new ArrayList();
ArrayList<PVector> starPositions = new ArrayList();
float mSpeed = 1;

void setup() {
  fullScreen(P3D);  // Use fullScreen with P3D for 3D rendering
  sunTexture = loadImage("sun.jpg");
  textures[0] = loadImage("neptune.jpg");
  textures[1] = loadImage("earth.jpg");
  textures[2] = loadImage("mars.jpg");
  
  cam = new PeasyCam(this, 400);  // Initialize PeasyCam

  // Generate star positions
  for (int i = 0; i < 1000; i++) {
    starPositions.add(new PVector(random(-width, width), random(-height, height), random(-width, width)));
  }

  // Create planets with 3D characteristics
  planets.add(new Planet(50, 0, 0, sunTexture));
  planets.get(0).spawnMoons(4, 1);

  for (int i = 0; i < 3; i++) {
    planets.add(new Planet(random(10, 30), random(100, 300), random(0.01, 0.03), textures[i]));
  }
}

void draw() {
  background(0);

  // Draw the stars
  pushMatrix();
  translate(width / 2, height / 2, -500);  // Center the stars and move them back a bit
  stroke(255);
  for (PVector star : starPositions) {
    point(star.x, star.y, star.z);
  }
  popMatrix();

  lights();
  planets.get(0).show();
  planets.get(0).orbit();
}

class Planet {
  float radius;
  float angle;
  float distance;
  Planet[] planets;
  float orbitSpeed;
  PVector v;
  PShape globe;

  Planet(float r, float d, float o, PImage img) {
    v = PVector.random3D();  // Generate random 3D vector
    radius = r;
    distance = d;
    v.mult(distance);  // Scale vector by distance
    angle = random(TWO_PI);
    orbitSpeed = o;
    globe = createShape(SPHERE, radius);  // Create sphere shape
    globe.setTexture(img);  // Apply texture
  }

  void orbit() {
    angle += orbitSpeed;
    if (planets != null) {
      for (Planet moon : planets) {
        moon.orbit();
      }
    }
  }

  void spawnMoons(int total, int level) {
    planets = new Planet[total];
    for (int i = 0; i < planets.length; i++) {
      float r = radius / (level + 1);
      float d = random(radius + r, (radius + r) * 3);
      float o = random(-0.02, 0.02);
      int index = int(random(0, textures.length));
      planets[i] = new Planet(r, d, o, textures[index]);
      if (level < 4) {
        int num = int(random(0, 4));
        planets[i].spawnMoons(num, level + 1);
      }
    }
  }

  void show() {
    pushMatrix();
    PVector axis = new PVector(1, 0, 1);  // Arbitrary axis for rotation
    PVector p = v.cross(axis);  // Find perpendicular vector for rotation
    rotate(angle, p.x, p.y, p.z);
    translate(v.x, v.y, v.z);
    shape(globe);  // Render the planet
    if (planets != null) {
      for (Planet moon : planets) {
        moon.show();
      }
    }
    popMatrix();
  }
}
