import queasycam.*;

QueasyCam cam;
int maxChunks = 100;
int maxAnimals = 1;
PShape chunkVBO[] = new PShape[maxChunks];
PShape chunkVBOTsp[] = new PShape[maxChunks];
Chunk chunk[] = new Chunk[maxChunks];
boolean updateChunk[] = new boolean[maxChunks];
boolean chunkLoaded[] = new boolean[maxChunks];
PImage mainTex,skyBoxTex,monsTex;
int chunkWidth = 16;
int chunkLength = 16;
int chunkHeight = 64;
float texScale = -0.9375;
PShape skyBox;
PShape blockSides;
boolean chunkOpen[] = new boolean[maxChunks];
int chunkPos[][] = new int[maxChunks][2];
PVector camLookat;
int cameraChunk;
boolean up,down,left,right,space;
float fogDistance = 0;
PShape animalShape[] = new PShape[maxAnimals];
Animal animal[] = new Animal[maxAnimals];

void setup() {
  size(800,600,P3D);
  frameRate(60);
  cam = new QueasyCam(this);
  cam.sensitivity = 0.2;
  cam.speed = 0.0;
  noiseSeed(12345);
  mainTex = loadImage("textureAtlas.png");
  skyBoxTex = loadImage("skybox2.png");
  monsTex = loadImage("birds.png");
  textureMode(NORMAL);
  createSkybox();
  initChunks();
  ((PGraphicsOpenGL)g).textureSampling(3);
  cam.position.x=int(noise(10)*1000)+0.5;
  cam.position.z=int(noise(42)*1000)+0.5;
  cam.position.y=5;
  initAnimals();
  thread("loadChunkBlocks");
}

void initChunks() {
  for(int i=0; i<maxChunks;i++){
    chunk[i]=new Chunk(i);
  }
}

void initAnimals(){
  for(int i=0; i<maxAnimals;i++){
    animal[i]=new Animal(i);
    animal[i].spawnAnimal();
  }
}

int farChunk;
float farDist;

int furthestChunk() {
  farDist=0;
  for(int i=0;i<maxChunks;i++){
    float camDist = dist(chunk[i].chunkX,chunk[i].chunkY,round(cam.position.x/16),round(cam.position.z/16));
    if(camDist>farDist){
      farDist = camDist;
      farChunk=i;
    }
  }
  return farChunk;
}

PVector nextChunkPos(){
  int genCenterX=round(cam.position.x/16);
  int genCenterY=round(cam.position.z/16);
  for(int x=round(genCenterX-sqrt(maxChunks)/2);x<round(genCenterX+sqrt(maxChunks)/2);x++){
    for(int y=round(genCenterY-sqrt(maxChunks)/2);y<round(genCenterY+sqrt(maxChunks)/2);y++){
      if(findChunk(x,y)==-1){
        return(new PVector(x,y));
      }
    }
  }
  return(new PVector(0,0));
}

PVector nextChunkPosSpiral( int X, int Y){
  int genCenterX=round(cam.position.x/16);
  int genCenterY=round(cam.position.z/16);
  int x,y,dx,dy;
  x = y = dx =0;
  dy = -1;
  int t = max(X,Y);
  int maxI = t*t;
  for(int i =0; i < maxI; i++){
    if ((-X/2 <= x) && (x <= X/2) && (-Y/2 <= y) && (y <= Y/2)){
      if(findChunk(x+genCenterX,y+genCenterY)==-1){
        return(new PVector(x+genCenterX,y+genCenterY));
      }
    }
    if( (x == y) || ((x < 0) && (x == -y)) || ((x > 0) && (x == 1-y))){
      t = dx;
      dx = -dy;
      dy = t;
    }
    x += dx;
    y += dy;
  }
  return(new PVector(0,0));
}

int findChunk(int x, int y) {
  for(int i=0;i<maxChunks;i++){
    if(chunk[i].chunkX==x&&chunk[i].chunkY==y){
      return(i);
    }
  }
  return(-1);
}

int findAvailable(){
  for(int i=0;i<maxChunks;i++){
    if(chunk[i].available){
      return(i);
    }
  }
  return(-1);
}

void draw() {
  background(0);
  drawSkyBox();
  //lightFalloff(1.0, 0.00, 0.01);
  //ambientLight(255, 255, 255, cam.position.x, cam.position.y, cam.position.z);
  drawChunks();
  drawTransparent();
  updateAnimalAi();
  drawAnimals();
  checkChunkUpdates();
  camCollisionsManager();
  println(cam.position,int(cam.position.x/16),int(cam.position.z/16),frameRate);
}

void updateAnimalAi(){
  for(int i=0;i<maxAnimals;i++){
    animal[i].updateAi();
    animal[i].updateModel();
  }
}

void drawAnimals(){
  for(int i=0;i<maxAnimals;i++){
    if(animal[i].onGround){
      pushMatrix();
      translate(animal[i].posX,animal[i].posY+0.5,animal[i].posZ);
      rotateY(-atan2(animal[i].posZ-cam.position.z,animal[i].posX-cam.position.x)+PI/2);
      shape(animalShape[i]);
      popMatrix();
    }
  }
}

float gravity = 0.017;
float yVelocity = 0;
float playerSpeed = 0.1;
boolean playerLanded = true;

void camCollisionsManager() {
  if(findBlock(cam.position.x+0.5,cam.position.y+yVelocity+2,cam.position.z+0.5)<10){
    yVelocity+=gravity;
  }else{
    yVelocity=0;
    playerLanded = true;
  }
  if(findBlock(cam.position.x+0.5,cam.position.y+yVelocity,cam.position.z+0.5)>10){
    yVelocity+=gravity;
  }
  if(space&&playerLanded){
    yVelocity+=-0.22;
    space=false;
    playerLanded = false;
  }
  cam.position.y+=yVelocity;
  if(up){
    if((findBlock(cam.position.x+0.5+cos(cam.pan)*playerSpeed,cam.position.y+1.9,cam.position.z+0.5)<10)&&(findBlock(cam.position.x+0.5+cos(cam.pan)*playerSpeed,cam.position.y+0.5,cam.position.z+0.5)<10)){
      cam.position.x+=cos(cam.pan)*playerSpeed;
    }
    if(findBlock(cam.position.x+0.5,cam.position.y+1.9,cam.position.z+0.5+sin(cam.pan)*playerSpeed)<10&&findBlock(cam.position.x+0.5,cam.position.y+0.5,cam.position.z+0.5+sin(cam.pan)*playerSpeed)<10){
      cam.position.z+=sin(cam.pan)*playerSpeed;
    }
    fogDistance+=0.00001;
  }
  if(down){
    if(findBlock(cam.position.x+0.5-cos(cam.pan)*playerSpeed,cam.position.y+1.9,cam.position.z+0.5)<10&&findBlock(cam.position.x+0.5-cos(cam.pan)*playerSpeed,cam.position.y+0.5,cam.position.z+0.5)<10){
      cam.position.x-=cos(cam.pan)*playerSpeed;
    }
    if(findBlock(cam.position.x+0.5,cam.position.y+1.9,cam.position.z+0.5-sin(cam.pan)*playerSpeed)<10&&findBlock(cam.position.x+0.5,cam.position.y+0.5,cam.position.z+0.5-sin(cam.pan)*playerSpeed)<10){
      cam.position.z-=sin(cam.pan)*playerSpeed;
    }
    fogDistance+=0.00001;
  }
  if(left){
    if(findBlock(cam.position.x+0.5+cos(cam.pan-PI/2)*playerSpeed,cam.position.y+1.9,cam.position.z+0.5)<10&&findBlock(cam.position.x+0.5+cos(cam.pan-PI/2)*playerSpeed,cam.position.y+0.5,cam.position.z+0.5)<10){
      cam.position.x+=cos(cam.pan-PI/2)*playerSpeed;
    }
    if(findBlock(cam.position.x+0.5,cam.position.y+1.9,cam.position.z+0.5+sin(cam.pan-PI/2)*playerSpeed)<10&&findBlock(cam.position.x+0.5,cam.position.y+0.5,cam.position.z+0.5+sin(cam.pan-PI/2)*playerSpeed)<10){
      cam.position.z+=sin(cam.pan-PI/2)*playerSpeed;
    }
    fogDistance+=0.00001;
  }
  if(right){
    if(findBlock(cam.position.x+0.5-cos(cam.pan-PI/2)*playerSpeed,cam.position.y+1.9,cam.position.z+0.5)<10&&findBlock(cam.position.x+0.5-cos(cam.pan-PI/2)*playerSpeed,cam.position.y+0.5,cam.position.z+0.5)<10){
      cam.position.x-=cos(cam.pan-PI/2)*playerSpeed;
    }
    if(findBlock(cam.position.x+0.5,cam.position.y+1.9,cam.position.z+0.5-sin(cam.pan-PI/2)*playerSpeed)<10&&findBlock(cam.position.x+0.5,cam.position.y+0.5,cam.position.z+0.5-sin(cam.pan-PI/2)*playerSpeed)<10){
      cam.position.z-=sin(cam.pan-PI/2)*playerSpeed;
    }
    fogDistance+=0.00001;
  }
}

int findBlock(float x, float y, float z){
  int blockChunk = 0;
  if(x<0||z<0){
    if(x<0&&z<0){
      blockChunk = findChunk(int(x/16)-1,int(z/16)-1);
    }else if(x<0){
      blockChunk = findChunk(int(x/16)-1,int(z/16));
    }else{
      blockChunk = findChunk(int(x/16),int(z/16)-1);
    }
  }else{
    blockChunk = findChunk(int(x/16),int(z/16));
  }
  if(blockChunk>-1&&chunkLoaded[blockChunk]){
      return(chunk[blockChunk].blockId[int(((x%16)+16)%16)][int(((y%64)+64)%64)][int(((z%16)+16)%16)]);
  }else{
    return(-1);
  }
}

void drawTransparent() {
  for(int i=0;i<maxChunks;i++){
    
    if(chunkLoaded[i]){
      shape(chunkVBOTsp[i]);
    }
  }
}
void drawChunks() {
  for(int i=0;i<maxChunks;i++){
    
    if(chunkLoaded[i]){
      shape(chunkVBO[i]);
    }
  }
}

int loadingChunk = 0;
boolean nextChunkPlz = true;
PVector nexChunk;

void checkChunkUpdates() {
  
  
  if(chunk[loadingChunk].available&&nextChunkPlz){
    nexChunk = nextChunkPosSpiral(int(sqrt(maxChunks)+10),int(sqrt(maxChunks)+10));
    doChunk = true;
    nextChunkPlz = false;
  }
  if(chunk[loadingChunk].initDone){
    chunk[loadingChunk].updateChunk(int(nexChunk.x),int(nexChunk.y));
    loadingChunk=furthestChunk();
    chunk[loadingChunk].unloadChunk();
    nextChunkPlz = true;
  }
}

boolean doChunk;
void loadChunkBlocks(){
  while(true){
    if(doChunk){
      chunk[loadingChunk].setBlockIds(int(nexChunk.x),int(nexChunk.y));
      doChunk=false;
    }
  }
}

int outtaViewChunk() {
  for(int i=0;i<maxChunks;i++) {
    PVector chunkDir = new PVector(cam.position.x/16-chunk[i].chunkX,cam.position.z/16-chunk[i].chunkY).normalize();
    PVector camDir = new PVector(cos(cam.pan),sin(cam.pan));
    if(chunkDir.dot(camDir)>0.5){
      return(i);
    }
  }
  return(-1);
}

int testInt = 0;
void keyPressed(){
  if(key=='w'){
    up=true;
  }
  if(key=='s'){
    down=true;
  }
  if(key=='a'){
    left=true;
  }
  if(key=='d'){
    right=true;
  }
  if(key==' '){
    space=true;
  }
}

void keyReleased(){
  if(key=='w'){
    up=false;
  }
  if(key=='s'){
    down=false;
  }
  if(key=='a'){
    left=false;
  }
  if(key=='d'){
    right=false;
  }
  if(key==' '){
    space=false;
  }
}