// Pixel Puzzle Edukasi - main sketch
// Loop utama, input, dan pengaturan kanvas internal 320x180 (4x).

GameState game;
UI ui;

public void settings() {
  size(GameState.W * GameState.SCALE, GameState.H * GameState.SCALE);
  noSmooth();
}

public void setup() {
  frameRate(60);
  surface.setTitle("Pixel Puzzle Edukasi");
  surface.setResizable(false);

  PFont fTiny = createFont("Monospaced", 6, true);
  PFont fSmall = createFont("Monospaced", 8, true);
  PFont fMid = createFont("Monospaced", 10, true);
  PFont fBig = createFont("Monospaced", 16, true);

  game = new GameState(this);
  ui = new UI(this, fTiny, fSmall, fMid, fBig);
  game.boot();
}

public void draw() {
  background(11, 13, 18);
  pushMatrix();
  scale(GameState.SCALE);
  game.update();
  ui.render(game);
  popMatrix();
}

public void mousePressed() {
  ui.mousePressed(game, mouseX / (float) GameState.SCALE, mouseY / (float) GameState.SCALE, mouseButton);
}

public void keyPressed() {
  ui.keyPressed(game);
}
