import processing.serial.*;

Serial myPort;
float angle = 0;
float distance = 0;
float alertDistance = 20; 
float sweepAngle = 0; // rotating line

void setup() {
  size(500, 500);
  background(0);
  myPort = new Serial(this, "COM7", 9600);
  myPort.bufferUntil('\n');
}

void draw() {
  // Fade previous frame slightly
  fill(0, 20); 
  noStroke();
  rect(0, 0, width, height);

  translate(width/2, height/2);

  // Draw radar circle and range marks
  stroke(0, 100, 0);
  noFill();
  ellipse(0, 0, 400, 400);
  ellipse(0, 0, 300, 300);
  ellipse(0, 0, 200, 200);
  ellipse(0, 0, 100, 100);

  // Draw sweeping line
  stroke(0, 255, 0, 100);
  line(0, 0, cos(radians(sweepAngle)) * 200, sin(radians(sweepAngle)) * 200);
  sweepAngle = (sweepAngle + 1) % 360;

  // Draw points from Arduino
  while (myPort.available() > 0) {
    String line = myPort.readStringUntil('\n');
    if (line != null) {
      line = line.trim();
      if (line.length() > 0) {
        String[] data = split(line, ',');
        if (data.length == 2) {
          angle = float(data[0]);
          distance = float(data[1]);

          if (distance > 0) {
            float x = cos(radians(angle)) * distance * 5;
            float y = sin(radians(angle)) * distance * 5;

            noStroke();
            if (distance < alertDistance) fill(255, 0, 0);
            else fill(0, 255, 0);

            ellipse(x, y, 8, 8);
          }
        }
      }
    }
  }
}
