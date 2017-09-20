class Animal{
  /*Animals:
  1=bird
  2=frog
  */
  int currentAnimal;
  float posX;
  float posY;
  float posZ;
  float direction;
  int animalNumber;
  float gravity = 0.017;
  float yVelocity = 0;
  boolean isRunning =true;
  boolean onGround = false;
  int runFrameX[] = {0,1,2,1};
  int runFrameY[] = {1,1,1,1};
  int currentFrame;
  int texPosX = 1;
  int texPosY = 1;
  long fChangeTime;
  Animal(int num){
    animalNumber = num;
    updateModel();
  }
  
  void updateAi(){
    if(!onGround){
      if(findBlock(posX,posY+yVelocity+1,posZ)<10){
        yVelocity+=gravity;
      }else{
        yVelocity=0;
        onGround=true;
        posY=floor(posY);
      }
      posY+=yVelocity;
    }else{
      if(isRunning&&millis()-fChangeTime>100){
        fChangeTime=millis();
        currentFrame++;
        if(currentFrame>3){
          currentFrame=0;
        }
        texPosX=runFrameX[currentFrame];
        texPosY=runFrameY[currentFrame];
      }
    }
  }
  int spawnDistance = 50;
  void spawnAnimal(){
    setPos(cam.position.x+(int(random(spawnDistance)-spawnDistance/2))+0.5,cam.position.y,cam.position.z+(int(random(spawnDistance)-spawnDistance/2))+0.5);
  }
  
  void setAnimal(int animType){
    currentAnimal = animType;
  }
  
  void setPos(float x_,float y_,float z_){
    posX=x_;
    posY=y_;
    posZ=z_;
  }
  
  void updateModel(){
    animalShape[animalNumber] = createShape();
    animalShape[animalNumber].beginShape();
    animalShape[animalNumber].noStroke();
    animalShape[animalNumber].texture(monsTex);
    animalShape[animalNumber].vertex(-1, -1, 0, 0+((1.0/12)*texPosX), 0+((1.0/8)*texPosY));
    animalShape[animalNumber].vertex(1, -1, 0, 1*(1.0/12)+((1.0/12)*texPosX), 0+((1.0/8)*texPosY));
    animalShape[animalNumber].vertex(1, 1, 0, 1*(1.0/12)+((1.0/12)*texPosX), 1*(1.0/8)+((1.0/8)*texPosY));
    animalShape[animalNumber].vertex(-1, 1, 0, 0+((1.0/12)*texPosX), 1*(1.0/8)+((1.0/8)*texPosY));
    animalShape[animalNumber].endShape();
  }
}