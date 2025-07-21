import ddf.minim.*;

// Global variables
int currentScene = 1;
float sceneTimer = 0;
float sceneDuration = 600; // Durasi tiap scene (20 detik)
boolean transitioning = false;
float transitionAlpha = 0;

// Audio
Minim minim;
AudioPlayer azanSound;
boolean azanPlayed = false;
// Images
PImage bgCity, bgMasjid, bgOffice;
PFont mainFont;

// Scene-specific variables
// Scene 1
float cloudX1 = 0, cloudX2 = 150, cloudX3 = 300;
ArrayList<WalkingPerson> people;
float[] scene1XPos = new float[5];
float[] scene1YPos = new float[5];
float[] scene1LegAngle = new float[5];
float[] scene1ArmAngle = new float[5];

// Scene 2
float[] xPos = new float[3];
float[] yPos = new float[3];
float[] legAngle = new float[3];
float[] armAngle = new float[3];
boolean isConversing = false;
float conversationTimer = 0;
String[] conversations = {
  "Eh, deadline project kita gimana?",
  "Masih banyak yang harus dikerjain nih",
  "Meeting nya jadi kan?",
  "Iya nih, banyak kerjaan"
};
int currentConversation = 0;
float dialogAlpha = 0;

// Scene 3
float antonX, antonY;
float breatheAnim = 0;
float thoughtTimer = 0;
boolean isThinkingWork = true;
float handMovement = 0;
float walkSpeed = 2;
boolean walkingRight = true;
float legAnimation = 0;

// Scene 4 variables
float scene4AntonX, scene4AntonY;
float scene4WalkAngle = 0;
float scene4LegAngle = 0;
float scene4ArmAngle = 0;
boolean isWalkingToMasjid = false;
float laptopAlpha = 255;
String[] scene4Thoughts = {
  "Astaghfirullah, hampir saja aku lupa...",
  "Allah lebih penting dari deadline",
  "Waktunya shalat dulu",
  "Semoga masih sempat berjamaah"
};
int currentThought = 0;
float scene4ThoughtTimer = 0;  // Mengubah nama variabel
float thoughtBubbleAlpha = 255;

// Scene 5 variables
float finalTextAlpha = 0;
color gradientTop = color(70, 130, 180);    // Steel blue
color gradientBottom = color(255, 200, 150); // Warm sunset
float finalMessageY = 0;

// Narrations
String[] narrations = {
  "Di tengah hiruk pikuk kota yang sibuk,\nAnton berjalan dengan tergesa-gesa menuju kantornya.\nWaktu terus berputar, rutinitas tak pernah berhenti.", // Scene 1
  "Namun, di antara deru kesibukan, sebuah panggilan suci mulai bergema.\nSuara azan berkumandang, menyerukan ketenangan\ndan mengundang hati untuk sejenak berhenti dari duniawi.", // Scene 2
  "Panggilan itu sampai ke hati seorang pekerja yang tenggelam dalam layar komputernya.\nSebuah dilema muncul: melanjutkan pekerjaan ataukah memenuhi panggilan suci itu?", // Scene 3
  "Setelah perenungan singkat, ia mematikan laptopnya dengan senyum tipis.\nCahaya senja menyambut langkahnya, saat ia memutuskan untuk menuju ke tempat panggilan itu datang." // Scene 4
};
float narrationAlpha = 255;

void setup() {
  size(800, 600);
  smooth();
  
  // Initialize audio
  minim = new Minim(this);
  azanSound = minim.loadFile("azan.mp3");
  
  // Load images
  bgCity = loadImage("city.jpg");
  bgMasjid = loadImage("Masjid.jpg");
  bgOffice = loadImage("dalam Kantor.jpg");
  
  // Initialize font
  mainFont = createFont("Arial", 32);
  textFont(mainFont);
  
  // Initialize Scene 1
  setupScene1();
  
  // Initialize Scene 2
  setupScene2();
  
  // Initialize Scene 3
  setupScene3();
  
  // Initialize Scene 4
  setupScene4();
  
  // Initialize Scene 5
  setupScene5();
}

void draw() {
  // Update scene timer
  sceneTimer++;
  
  // Check for scene transition
  if (sceneTimer >= sceneDuration && !transitioning) {
    startTransition();
  }
  
  // Draw current scene
  switch(currentScene) {
    case 1:
      drawScene1();
      break;
    case 2:
      drawScene2();
      break;
    case 3:
      drawScene3();
      break;
    case 4:
      drawScene4();
      break;
    case 5:
      drawScene5();
      break;
  }
  
  // Draw transition overlay if transitioning
  if (transitioning) {
    drawTransition();
  }
}

void startTransition() {
  transitioning = true;
  transitionAlpha = 0;
}

void drawTransition() {
  // Fade to black
  fill(0, transitionAlpha);
  rect(0, 0, width, height);
  
  transitionAlpha += 5;
  
  // When fully black, switch scene
  if (transitionAlpha >= 255) {
    // Stop azan sound if leaving Scene 2
    if (currentScene == 2) {
      azanSound.pause();
      azanSound.rewind();
    }
    
    currentScene++;
    if (currentScene > 5) currentScene = 1; // Update to include Scene 5
    sceneTimer = 0;
    transitioning = false;
    narrationAlpha = 255;
    
    // Reset scene-specific variables
    switch(currentScene) {
      case 1:
        setupScene1();
        break;
      case 2:
        setupScene2();
        break;
      case 3:
        setupScene3();
        break;
      case 4:
        setupScene4();
        break;
      case 5:
        setupScene5();
        break;
    }
  }
}

// Scene 1 Functions
void setupScene1() {
  people = new ArrayList<WalkingPerson>();
  
  // Initialize people positions
  for (int i = 0; i < 5; i++) {
    scene1XPos[i] = width * (0.2 + i * 0.15);
    scene1YPos[i] = height - 80; // Posisi lebih rendah
    scene1LegAngle[i] = 0;
    scene1ArmAngle[i] = 0;
    people.add(new WalkingPerson(scene1XPos[i], scene1YPos[i], i == 0));
  }
}

void drawScene1() {
  // Draw background
  image(bgCity, 0, 0, width, height);
  
  // Update and draw clouds
  drawClouds();
  
  // Update and draw people
  for (int i = 0; i < people.size(); i++) {
    WalkingPerson person = people.get(i);
    person.update();
    person.display();
  }
  
  // Draw narration
  drawNarration(0);
}

// Scene 2 Functions
void setupScene2() {
  // Reset positions
  for (int i = 0; i < 3; i++) {
    xPos[i] = width * (0.3 + i * 0.2);
    yPos[i] = height - 80;
    legAngle[i] = 0;
    armAngle[i] = 0;
  }
  isConversing = false;
  conversationTimer = 0;
  currentConversation = 0;
  dialogAlpha = 0;
  
  // Start azan sound
  if (!azanPlayed) {
    azanSound.rewind();
    azanSound.play();
    azanPlayed = true;
  }
}

void drawScene2() {
  // Draw background
  image(bgMasjid, 0, 0, width, height);
  
  // Update characters
  updateScene2Characters();
  
  // Draw characters
  for (int i = 0; i < 3; i++) {
    drawCharacter(i);
  }
  
  // Draw conversation if active
  if (isConversing) {
    drawConversation();
  }
  
  // Draw narration
  drawNarration(1);
}

// Scene 3 Functions
void setupScene3() {
  antonX = width/2;
  antonY = height - 50;
  breatheAnim = 0;
  thoughtTimer = 0;
  isThinkingWork = true;
  walkSpeed = 2;
  walkingRight = true;
  legAnimation = 0;
}

void drawScene3() {
  // Draw background
  image(bgOffice, 0, 0, width, height);
  
  // Update animations
  updateScene3Animations();
  
  // Draw Anton
  drawAnton();
  
  // Draw thought bubble
  drawThoughtBubble();
  
  // Draw narration
  drawNarration(2);
}

// Scene 4 Functions
void setupScene4() {
  scene4AntonX = width/2;
  scene4AntonY = height - 80;
  isWalkingToMasjid = false;
  laptopAlpha = 255;
  currentThought = 0;
  scene4ThoughtTimer = 0;
  thoughtBubbleAlpha = 255;
}

void drawScene4() {
  // Draw background
  image(bgMasjid, 0, 0, width, height);
  
  // Add subtle overlay for evening atmosphere
  fill(255, 200, 150, 50); // Warm evening light
  rect(0, 0, width, height);
  
  // Update animations
  updateScene4Animations();
  
  // Draw laptop if still visible
  if (laptopAlpha > 0) {
    drawLaptop();
  }
  
  // Draw Anton
  drawScene4Anton();
  
  // Draw thought bubble
  if (thoughtBubbleAlpha > 0) {
    drawScene4ThoughtBubble();
  }
  
  // Draw narration
  drawNarration(3);
}

// Scene 5 Functions
void setupScene5() {
  finalTextAlpha = 0;
  finalMessageY = height + 50; // Start below screen
}

void drawScene5() {
  // Draw gradient background
  drawGradientBackground();
  
  // Update and draw final message
  updateScene5Animations();
  drawFinalMessage();
}

void drawGradientBackground() {
  // Draw gradient from top to bottom
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    color c = lerpColor(gradientTop, gradientBottom, inter);
    stroke(c);
    line(0, y, width, y);
  }
}

void updateScene5Animations() {
  // Fade in text
  if (sceneTimer < 60) {
    finalTextAlpha = min(255, finalTextAlpha + 2);
  }
  
  // Move text up
  if (finalMessageY > height/2) {
    finalMessageY = lerp(finalMessageY, height/2, 0.05);
  }
}

void drawFinalMessage() {
  // Draw decorative elements
  stroke(255, finalTextAlpha * 0.7);
  strokeWeight(2);
  
  // Top decorative line
  line(width/4, finalMessageY - 80, width * 3/4, finalMessageY - 80);
  // Bottom decorative line
  line(width/4, finalMessageY + 80, width * 3/4, finalMessageY + 80);
  
  // Draw small ornaments
  float ornamentSize = 20;
  noFill();
  // Top ornaments
  ellipse(width/4, finalMessageY - 80, ornamentSize, ornamentSize);
  ellipse(width * 3/4, finalMessageY - 80, ornamentSize, ornamentSize);
  // Bottom ornaments
  ellipse(width/4, finalMessageY + 80, ornamentSize, ornamentSize);
  ellipse(width * 3/4, finalMessageY + 80, ornamentSize, ornamentSize);
  
  // Draw main text
  textAlign(CENTER, CENTER);
  fill(255, finalTextAlpha);
  textSize(24);
  text("Di tengah segala kesibukan dunia,\njangan pernah lupakan panggilan-Nya.", width/2, finalMessageY - 20);
  
  // Draw secondary text
  textSize(20);
  fill(255, finalTextAlpha * 0.8);
  text("Karena di situlah ketenangan\ndan keberkahan sejati berada.", width/2, finalMessageY + 40);
  
  // Draw small Islamic ornaments
  drawIslamicOrnaments(finalTextAlpha);
}

void drawIslamicOrnaments(float alpha) {
  // Draw crescent moon
  noFill();
  stroke(255, alpha * 0.7);
  strokeWeight(2);
  arc(width/2, finalMessageY - 120, 40, 40, -PI/4, PI + PI/4);
  arc(width/2 - 5, finalMessageY - 120, 35, 35, -PI/4, PI + PI/4);
  
  // Draw star
  pushMatrix();
  translate(width/2 + 15, finalMessageY - 125);
  float starSize = 10;
  beginShape();
  for (int i = 0; i < 5; i++) {
    float angle = TWO_PI * i / 5 - PI/2;
    vertex(cos(angle) * starSize, sin(angle) * starSize);
    angle += TWO_PI / 10;
    vertex(cos(angle) * starSize/2, sin(angle) * starSize/2);
  }
  endShape(CLOSE);
  popMatrix();
}

// Shared Functions
void drawNarration(int sceneIndex) {
  if (narrationAlpha > 0) {
    // Background for text
    fill(0, narrationAlpha * 0.7);
    rect(0, height - 120, width, 120);
    
    // Text
    fill(255, narrationAlpha);
    textAlign(CENTER, CENTER);
    textSize(16);
    text(narrations[sceneIndex], width/2, height - 60);
    
    // Fade out slowly
    narrationAlpha = max(0, narrationAlpha - 0.5);
  }
}

void stop() {
  azanSound.close();
  minim.stop();
  super.stop();
}

// Include all necessary classes (Car, Person) and remaining functions here
// Copy the relevant class definitions and functions from the individual scene files

// Note: You'll need to add the remaining class definitions and helper functions
// from the individual scene files (Car, Person, drawClouds, updateScene2Characters,
// drawCharacter, drawConversation, updateScene3Animations, drawAnton, drawThoughtBubble) 

// Classes and supporting functions
class WalkingPerson {
  float x, y;
  float speed;
  boolean isMain;
  float walkAngle = 0;
  float animOffset;
  
  WalkingPerson(float x, float y, boolean isMain) {
    this.x = x;
    this.y = y;
    this.isMain = isMain;
    this.speed = 1;
    this.animOffset = random(TWO_PI);
  }
  
  void update() {
    x += speed;
    if (x > width + 30) x = -30;
    walkAngle = sin(frameCount * 0.1 + animOffset) * 0.3;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    scale(1.5);
    
    // Shadow
    fill(0, 50);
    noStroke();
    ellipse(0, 5, 30, 10);
    
    // Legs with walking animation
    fill(70);
    pushMatrix();
    translate(0, -20);
    rotate(walkAngle);
    rect(-12, 0, 8, 25, 2);
    popMatrix();
    
    pushMatrix();
    translate(0, -20);
    rotate(-walkAngle);
    rect(4, 0, 8, 25, 2);
    popMatrix();
    
    // Body
    fill(isMain ? color(70, 70, 90) : color(120, 120, 150));
    rect(-15, -65, 30, 40, 5);
    
    if (isMain) { // Anton
      // Shirt and tie
      fill(255);
      rect(-10, -63, 20, 38);
      fill(150, 50, 50);
      beginShape();
      vertex(0, -60);
      vertex(-3, -55);
      vertex(0, -40);
      vertex(3, -55);
      endShape(CLOSE);
    }
    
    // Head
    fill(255, 220, 180);
    ellipse(0, -75, 25, 25);
    
    // Hair
    fill(30);
    if (isMain) {
      arc(0, -75, 25, 25, -PI, 0);
      rect(-12, -87, 24, 12, 5);
    } else {
      beginShape();
      vertex(-12, -87);
      vertex(12, -87);
      vertex(15, -75);
      vertex(-15, -75);
      endShape(CLOSE);
    }
    
    // Face
    if (isMain) {
      // Glasses
      noFill();
      stroke(0);
      strokeWeight(1);
      ellipse(-5, -77, 8, 8);
      ellipse(5, -77, 8, 8);
      line(-1, -77, 1, -77);
    }
    
    // Eyes and mouth
    fill(0);
    ellipse(-5, -77, 3, 3);
    ellipse(5, -77, 3, 3);
    
    noFill();
    stroke(0);
    arc(0, -72, 8, 4, 0, PI);
    
    noStroke();
    popMatrix();
  }
}

class Person {
  float x, y;
  float speed;
  color clothesColor;
  int type;
  float animOffset;
  boolean isMain;
  float walkAngle = 0;
  
  Person(float x, float y, int type, boolean isMain) {
    this.x = x;
    this.y = y;
    this.type = type;
    this.isMain = isMain;
    this.speed = random(1, 3);
    this.clothesColor = isMain ? color(255, 100, 100) : color(random(100, 200));
    this.animOffset = random(TWO_PI);
  }
  
  void update() {
    x += speed;
    if (x > width + 30) x = -30;
    walkAngle = sin(frameCount * 0.1 + animOffset) * 0.3;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    scale(1.2);
    
    // Legs with walking animation
    fill(70);
    pushMatrix();
    translate(0, -20);
    rotate(walkAngle);
    rect(-5, 0, 4, 20);
    popMatrix();
    
    pushMatrix();
    translate(0, -20);
    rotate(-walkAngle);
    rect(1, 0, 4, 20);
    popMatrix();
    
    // Body
    fill(clothesColor);
    rect(-10, -45, 20, 25, 3);
    
    // Head
    fill(255, 220, 180);
    ellipse(0, -55, 15, 15);
    
    // Arms with walking animation
    fill(clothesColor);
    pushMatrix();
    translate(-8, -40);
    rotate(-walkAngle);
    rect(-2, 0, 4, 15);
    popMatrix();
    
    pushMatrix();
    translate(8, -40);
    rotate(walkAngle);
    rect(-2, 0, 4, 15);
    popMatrix();
    
    popMatrix();
  }
}

void drawClouds() {
  fill(255, 150);
  noStroke();
  
  // Cloud 1
  ellipse(cloudX1, 50, 60, 40);
  ellipse(cloudX1 + 20, 50, 70, 50);
  ellipse(cloudX1 - 20, 50, 50, 30);
  
  // Cloud 2
  ellipse(cloudX2, 80, 70, 45);
  ellipse(cloudX2 + 25, 80, 80, 55);
  ellipse(cloudX2 - 25, 80, 60, 35);
  
  // Cloud 3
  ellipse(cloudX3, 30, 65, 42);
  ellipse(cloudX3 + 22, 30, 75, 52);
  ellipse(cloudX3 - 22, 30, 55, 32);
  
  // Move clouds
  cloudX1 += 0.5;
  cloudX2 += 0.3;
  cloudX3 += 0.4;
  
  // Reset clouds position
  if (cloudX1 > width + 100) cloudX1 = -100;
  if (cloudX2 > width + 100) cloudX2 = -100;
  if (cloudX3 > width + 100) cloudX3 = -100;
}

void updateScene2Characters() {
  // Update walking animation
  for (int i = 0; i < 3; i++) {
    legAngle[i] = sin(frameCount * 0.1) * 0.3;
    armAngle[i] = -sin(frameCount * 0.1) * 0.3;
  }
  
  // Handle conversation state
  if (sceneTimer > 120 && sceneTimer < 300) {
    isConversing = true;
    // Move characters closer together
    xPos[0] = lerp(xPos[0], width * 0.45, 0.02);
    xPos[1] = lerp(xPos[1], width * 0.55, 0.02);
    xPos[2] = lerp(xPos[2], width * 0.65, 0.02);
  } else if (sceneTimer >= 300) {
    isConversing = false;
    // Move Anton away
    xPos[0] -= 2;
  }
  
  // Update conversation
  if (isConversing) {
    conversationTimer += 0.02;
    if (conversationTimer > 2) {
      conversationTimer = 0;
      currentConversation = (currentConversation + 1) % conversations.length;
    }
    dialogAlpha = 255;
  } else {
    dialogAlpha = max(0, dialogAlpha - 5);
  }
}

void drawCharacter(int index) {
  pushMatrix();
  translate(xPos[index], yPos[index]);
  scale(1.5);
  
  // Shadow
  fill(0, 50);
  noStroke();
  ellipse(0, 5, 30, 10);
  
  // Legs with walking animation
  fill(70);
  pushMatrix();
  translate(0, -20);
  rotate(legAngle[index]);
  rect(-12, 0, 8, 25, 2);
  popMatrix();
  
  pushMatrix();
  translate(0, -20);
  rotate(-legAngle[index]);
  rect(4, 0, 8, 25, 2);
  popMatrix();
  
  // Body
  fill(index == 0 ? color(70, 70, 90) : color(120, 120, 150));
  rect(-15, -65, 30, 40, 5);
  
  if (index == 0) { // Anton
    // Shirt and tie
    fill(255);
    rect(-10, -63, 20, 38);
    fill(150, 50, 50);
    beginShape();
    vertex(0, -60);
    vertex(-3, -55);
    vertex(0, -40);
    vertex(3, -55);
    endShape(CLOSE);
  }
  
  // Head
  fill(255, 220, 180);
  ellipse(0, -75, 25, 25);
  
  // Hair
  fill(30);
  if (index == 0) {
    arc(0, -75, 25, 25, -PI, 0);
    rect(-12, -87, 24, 12, 5);
  } else {
    beginShape();
    vertex(-12, -87);
    vertex(12, -87);
    vertex(15, -75);
    vertex(-15, -75);
    endShape(CLOSE);
  }
  
  // Face
  if (index == 0) {
    // Glasses
    noFill();
    stroke(0);
    strokeWeight(1);
    ellipse(-5, -77, 8, 8);
    ellipse(5, -77, 8, 8);
    line(-1, -77, 1, -77);
  }
  
  // Eyes and mouth
  fill(0);
  ellipse(-5, -77, 3, 3);
  ellipse(5, -77, 3, 3);
  
  noFill();
  stroke(0);
  if (isConversing) {
    float mouthOpen = sin(frameCount * 0.2) * 2;
    arc(0, -72, 8, 6 + mouthOpen, 0, PI);
  } else {
    arc(0, -72, 8, 4, 0, PI);
  }
  
  noStroke();
  popMatrix();
}

void drawConversation() {
  fill(255, dialogAlpha);
  stroke(0, dialogAlpha);
  strokeWeight(1);
  
  if (currentConversation % 2 == 0) {
    // Dialog for Anton
    rect(xPos[0] - 60, yPos[0] - 180, 120, 40, 10);
    triangle(xPos[0], yPos[0] - 140,
            xPos[0] - 10, yPos[0] - 150,
            xPos[0] + 10, yPos[0] - 150);
    
    fill(0, dialogAlpha);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(conversations[currentConversation], xPos[0], yPos[0] - 160);
  } else {
    // Dialog for other character
    rect(xPos[1] - 60, yPos[1] - 180, 120, 40, 10);
    triangle(xPos[1], yPos[1] - 140,
            xPos[1] - 10, yPos[1] - 150,
            xPos[1] + 10, yPos[1] - 150);
    
    fill(0, dialogAlpha);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(conversations[currentConversation], xPos[1], yPos[1] - 160);
  }
}

void updateScene3Animations() {
  // Walking animation
  if (walkingRight) {
    antonX += walkSpeed;
    if (antonX > width - 100) walkingRight = false;
  } else {
    antonX -= walkSpeed;
    if (antonX < 100) walkingRight = true;
  }
  
  legAnimation += 0.1;
  breatheAnim = sin(frameCount * 0.05) * 2;
  
  // Thought switching
  thoughtTimer += 0.02;
  if (thoughtTimer > PI) {
    thoughtTimer = 0;
    isThinkingWork = !isThinkingWork;
  }
}

void updateScene4Animations() {
  // First phase: Anton at laptop
  if (sceneTimer < 120) {
    // Fade out laptop
    laptopAlpha = max(0, laptopAlpha - 2);
  } else {
    // Second phase: Walking to masjid
    isWalkingToMasjid = true;
    scene4AntonX += 2;
    scene4LegAngle = sin(frameCount * 0.1) * 0.3;
    scene4ArmAngle = -sin(frameCount * 0.1) * 0.3;
  }
  
  // Update thought bubble
  if (sceneTimer > 60 && sceneTimer < 300) {
    scene4ThoughtTimer += 0.02;
    if (scene4ThoughtTimer > 2) {
      scene4ThoughtTimer = 0;
      currentThought = (currentThought + 1) % scene4Thoughts.length;
    }
    thoughtBubbleAlpha = 255;
  } else {
    thoughtBubbleAlpha = max(0, thoughtBubbleAlpha - 5);
  }
}

void drawAnton() {
  pushMatrix();
  translate(antonX, antonY + breatheAnim + abs(sin(legAnimation) * 5));
  scale(1.5);
  if (!walkingRight) scale(-1, 1);
  
  // Shadow
  fill(0, 50);
  noStroke();
  ellipse(0, 5, 30, 10);
  
  // Legs
  fill(70);
  pushMatrix();
  translate(0, -20);
  rotate(sin(legAnimation) * 0.3);
  rect(-12, 0, 8, 25, 2);
  popMatrix();
  
  pushMatrix();
  translate(0, -20);
  rotate(-sin(legAnimation) * 0.3);
  rect(4, 0, 8, 25, 2);
  popMatrix();
  
  // Body (suit)
  fill(70, 70, 90);
  rect(-15, -65, 30, 40, 5);
  
  // Shirt and tie
  fill(255);
  rect(-10, -63, 20, 38);
  fill(150, 50, 50);
  beginShape();
  vertex(0, -60);
  vertex(-3, -55);
  vertex(0, -40);
  vertex(3, -55);
  endShape(CLOSE);
  
  // Head
  fill(255, 220, 180);
  ellipse(0, -75, 25, 25);
  
  // Hair
  fill(30);
  arc(0, -75, 25, 25, -PI, 0);
  rect(-12, -87, 24, 12, 5);
  
  // Face
  // Glasses
  noFill();
  stroke(0);
  strokeWeight(1);
  ellipse(-5, -77, 8, 8);
  ellipse(5, -77, 8, 8);
  line(-1, -77, 1, -77);
  
  // Eyes and mouth
  fill(0);
  ellipse(-5, -77, 3, 3);
  ellipse(5, -77, 3, 3);
  
  noFill();
  stroke(0);
  if (isThinkingWork) {
    line(-4, -72, 4, -72);
  } else {
    arc(0, -72, 8, 4, 0, PI);
  }
  
  noStroke();
  popMatrix();
}

void drawThoughtBubble() {
  pushMatrix();
  translate(antonX + (walkingRight ? 30 : -30), 0);
  
  // Bubbles
  fill(255, 200);
  float bubbleY = antonY - 120;
  
  // Small bubbles
  ellipse(antonX - 20, bubbleY + 30, 10, 10);
  ellipse(antonX - 10, bubbleY + 20, 15, 15);
  
  // Main bubble
  ellipse(antonX, bubbleY, 60, 45);
  
  // Thought content
  if (isThinkingWork) {
    // Laptop icon
    fill(100);
    rect(antonX - 15, bubbleY - 10, 30, 20, 3);
    fill(150, 200, 255);
    rect(antonX - 13, bubbleY - 8, 26, 16, 2);
  } else {
    // Masjid icon
    fill(0, 150, 0);
    // Base
    rect(antonX - 15, bubbleY - 10, 30, 15, 3);
    // Dome
    arc(antonX, bubbleY - 10, 20, 20, -PI, 0);
    // Minarets
    rect(antonX - 12, bubbleY - 20, 4, 15, 1);
    rect(antonX + 8, bubbleY - 20, 4, 15, 1);
  }
  
  popMatrix();
} 

void drawLaptop() {
  pushMatrix();
  translate(scene4AntonX - 30, scene4AntonY - 40);
  
  // Laptop with fading effect
  fill(50, laptopAlpha);
  rect(-20, 0, 40, 5, 2);
  
  pushMatrix();
  translate(0, -2);
  rotate(-PI/8);
  fill(30, laptopAlpha);
  rect(-25, -30, 50, 30, 3);
  fill(100, 150, 255, laptopAlpha * 0.5);
  rect(-23, -28, 46, 26, 2);
  popMatrix();
  
  popMatrix();
}

void drawScene4Anton() {
  pushMatrix();
  translate(scene4AntonX, scene4AntonY);
  scale(1.5);
  
  // Shadow
  fill(0, 50);
  noStroke();
  ellipse(0, 5, 30, 10);
  
  // Legs with walking animation
  fill(70);
  pushMatrix();
  translate(0, -20);
  rotate(scene4LegAngle);
  rect(-12, 0, 8, 25, 2);
  popMatrix();
  
  pushMatrix();
  translate(0, -20);
  rotate(-scene4LegAngle);
  rect(4, 0, 8, 25, 2);
  popMatrix();
  
  // Arms with walking animation
  fill(70, 70, 90);
  // Left arm
  pushMatrix();
  translate(-15, -55);
  rotate(scene4ArmAngle);
  rect(-3, 0, 6, 25, 2);
  // Left hand
  pushMatrix();
  translate(0, 25);
  fill(255, 220, 180);
  ellipse(0, 0, 8, 8);
  popMatrix();
  popMatrix();
  
  // Right arm
  pushMatrix();
  translate(15, -55);
  rotate(-scene4ArmAngle);
  fill(70, 70, 90);
  rect(-3, 0, 6, 25, 2);
  // Right hand
  pushMatrix();
  translate(0, 25);
  fill(255, 220, 180);
  ellipse(0, 0, 8, 8);
  popMatrix();
  popMatrix();
  
  // Body (suit)
  fill(70, 70, 90);
  rect(-15, -65, 30, 40, 5);
  
  // Shirt and tie
  fill(255);
  rect(-10, -63, 20, 38);
  fill(150, 50, 50);
  beginShape();
  vertex(0, -60);
  vertex(-3, -55);
  vertex(0, -40);
  vertex(3, -55);
  endShape(CLOSE);
  
  // Head
  fill(255, 220, 180);
  ellipse(0, -75, 25, 25);
  
  // Hair
  fill(30);
  arc(0, -75, 25, 25, -PI, 0);
  rect(-12, -87, 24, 12, 5);
  
  // Face
  // Glasses
  noFill();
  stroke(0);
  strokeWeight(1);
  ellipse(-5, -77, 8, 8);
  ellipse(5, -77, 8, 8);
  line(-1, -77, 1, -77);
  
  // Eyes
  fill(0);
  ellipse(-5, -77, 3, 3);
  ellipse(5, -77, 3, 3);
  
  // Smiling mouth
  noFill();
  stroke(0);
  arc(0, -72, 8, 6, 0, PI);
  
  noStroke();
  popMatrix();
}

void drawScene4ThoughtBubble() {
  pushMatrix();
  translate(scene4AntonX + 30, 0);
  
  // Bubbles
  fill(255, thoughtBubbleAlpha);
  float bubbleY = scene4AntonY - 120;
  
  // Small bubbles
  ellipse(scene4AntonX - 20, bubbleY + 30, 10, 10);
  ellipse(scene4AntonX - 10, bubbleY + 20, 15, 15);
  
  // Main bubble
  stroke(0, thoughtBubbleAlpha);
  strokeWeight(1);
  fill(255, thoughtBubbleAlpha);
  rect(scene4AntonX - 80, bubbleY - 30, 160, 40, 10);
  
  // Text
  fill(0, thoughtBubbleAlpha);
  textAlign(CENTER, CENTER);
  textSize(12);
  text(scene4Thoughts[currentThought], scene4AntonX, bubbleY - 10);
  
  noStroke();
  popMatrix();
} 
