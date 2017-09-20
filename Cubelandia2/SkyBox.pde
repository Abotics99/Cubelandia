void drawSkyBox(){
  pushMatrix();
  translate(cam.position.x,cam.position.y,cam.position.z);
  scale(500);
  shape(skyBox);
  popMatrix();
}

void createSkybox() {
  float skyTexScale1 = -0.75;
  float skyTexScale2 = -0.75;
  skyBox = createShape();
  skyBox.beginShape(QUADS);
  skyBox.texture(skyBoxTex);
  skyBox.noStroke();
  int skyTexPosX=1;
  int skyTexPosY=1;
  skyBox.vertex(-1, -1,  1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1, -1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1,  1,  1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyTexPosX=3;
  skyTexPosY=1;
  skyBox.vertex( 1, -1, -1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1, -1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1,  1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1, -1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyTexPosX=1;
  skyTexPosY=2;
  skyBox.vertex(-1,  1,  1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1,  1, -1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyTexPosX=1;
  skyTexPosY=0;
  skyBox.vertex(-1, -1, -1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1, -1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1, -1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1, -1,  1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyTexPosX=2;
  skyTexPosY=1;
  skyBox.vertex( 1, -1,  1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1, -1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1, -1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex( 1,  1,  1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyTexPosX=0;
  skyTexPosY=1;
  skyBox.vertex(-1, -1, -1, 0+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1, -1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 0+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1,  1,  1, 1+skyTexScale1+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.vertex(-1,  1, -1, 0+((1+skyTexScale2)*skyTexPosX), 1+skyTexScale1+((1+skyTexScale2)*skyTexPosY));
  skyBox.endShape();
}