class Chunk{
  int chunkX;
  int chunkY;
  int chunkId;
  int blockId[][][] = new int[16][64][16];
  int blockX,blockY,blockZ;
  int face[] = new int[6];
  int texPosX;
  int texPosY;
  boolean available = true;
  boolean initDone = false;
  Chunk(int chId){
    chunkId=chId;
  }
  void setBlockIds(int x_, int y_){
    chunkX=x_;
    chunkY=y_;
    for(int x=0;x<chunkWidth;x++){
      for(int y=0;y<chunkHeight;y++){
        for(int z=0;z<chunkLength;z++){
          blockId[x][y][z] = terrainGenerator(x,y,z);
        }
      }
    }
    for(int x=-3;x<chunkWidth+3;x++){
      for(int y=0;y<chunkHeight;y++){
        for(int z=-3;z<chunkLength+3;z++){
          plantTree(x,y,z);
        }
      }
    }
    for(int x=0;x<chunkWidth;x++){
      for(int y=0;y<chunkHeight;y++){
        for(int z=0;z<chunkLength;z++){
          plantGroundcover(x,y,z);
        }
      }
    }
    initDone = true;
  }
  
  int terrainGenerator(int x, int y, int z){
    if(noise((x+(chunkX*16))*0.02,(z+(chunkY*16))*0.02)/2<(y)*0.008){
      return(11);
    }else{
      return(0);
    }
  }
  
  void plantTree(int x,int y, int z){
    if((noise((x+(chunkX*16))*1,(z+(chunkY*16))*1)*10>(noise((x+(chunkX*20))*0.01,(z+(chunkY*20))*0.01)*10)+4)&&(noise((x+(chunkX*16))*0.02,(z+(chunkY*16))*0.02)/2>(y)*0.008&&noise((x+(chunkX*16))*0.02,(z+(chunkY*16))*0.02)/2<(y+1)*0.008)){
      int treeTop = 0;
      for(int i=0;i<int(noise((x+(chunkX*16))*0.1,(z+(chunkY*16))*0.1)*20);i++){
        if(y-i>0&&x>=0&&x<16&&z>=0&&z<16){
          blockId[x][y-i][z] = 14;
        }
        treeTop++;
      }
      for(int i=-2;i<3;i++){
        for(int j=-2;j<3;j++){
          for(int k=-2;k<3;k++){
            if(y-treeTop-j>0&&x-i>=0&&x-i<16&&z-k>=0&&z-k<16&&blockId[x-i][y-treeTop-j][z-k] == 0){
              blockId[x-i][y-treeTop-j][z-k] = treeTopArray[j+2][i+2][k+2];
            }
          }
        }
      }
    }
  }
  
  void plantGroundcover(int x,int y, int z) {
    if((noise((x+(chunkX*16))*1,(z+(chunkY*16))*1)*10>7)&&(noise((x+(chunkX*16))*0.02,(z+(chunkY*16))*0.02)/2>(y)*0.008&&noise((x+(chunkX*16))*0.02,(z+(chunkY*16))*0.02)/2<(y+1)*0.008)&&blockId[x][y][z]!=14){
      blockId[x][y][z] = 1;
    }
  }
  
  void unloadChunk(){
    available = true;
    chunkLoaded[chunkId] = false;
    initDone = false;
  }
  
  void updateChunk(int x_,int y_) {
    chunkX=x_;
    chunkY=y_;
    chunkVBO[chunkId] = createShape();
    chunkVBOTsp[chunkId] = createShape();
    chunkVBO[chunkId].beginShape(QUADS);
    chunkVBOTsp[chunkId].beginShape(QUADS);
    for(int x=0;x<chunkWidth;x++){
      for(int y=0;y<chunkHeight;y++){
        for(int z=0;z<chunkLength;z++){
          blockX=x;
          blockY=y;
          blockZ=z;
          checkCulling();
        }
      }
    }
    chunkVBO[chunkId].endShape();
    chunkVBOTsp[chunkId].endShape();
    chunkLoaded[chunkId] = true;
    available=false;
  }
  
  void setFacesToVBO(){
    checkSpecBlocks();
    setTexSide();
    if(blockId[blockX][blockY][blockZ]>10){
      if(face[0]==1){
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(200);
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
      if(face[1]==1){
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(125);
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
      if(face[2]==1){
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(150);
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
      if(face[3]==1){
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(100);
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
      if(face[4]==1){
        setTexBottom();
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(50);
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
      if(face[5]==1){
        setTexTop();
        chunkVBO[chunkId].noStroke();
        chunkVBO[chunkId].texture(mainTex);
        chunkVBO[chunkId].tint(255);
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY, -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
        chunkVBO[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      }
    }else if(blockId[blockX][blockY][blockZ]==1){
      setTexSide();
      chunkVBOTsp[chunkId].noStroke();
      chunkVBOTsp[chunkId].texture(mainTex);
      chunkVBOTsp[chunkId].tint(255);
      chunkVBOTsp[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY,  -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY,  -0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex(-0.5+blockX+(chunkX*16), -0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex( 0.5+blockX+(chunkX*16), -0.5+blockY,  -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 0+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex( 0.5+blockX+(chunkX*16),  0.5+blockY,  -0.5+blockZ+(chunkY*16), 1+texScale+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
      chunkVBOTsp[chunkId].vertex(-0.5+blockX+(chunkX*16),  0.5+blockY,  0.5+blockZ+(chunkY*16), 0+((1+texScale)*texPosX), 1+texScale+((1+texScale)*texPosY));
    }
  }
  
  void checkCulling(){
    if((blockZ==chunkLength-1||blockId[blockX][blockY][blockZ+1]<10)&&(blockZ!=chunkLength-1||terrainGenerator(blockX,blockY,blockZ+1)<10)){
      face[0]=1;
    }else{
      face[0]=0;
    }
    if((blockZ==0||blockId[blockX][blockY][blockZ-1]<10)&&(blockZ!=0||terrainGenerator(blockX,blockY,blockZ-1)<10)){
      face[1]=1;
    }else{
      face[1]=0;
    }
    if((blockX==chunkWidth-1||blockId[blockX+1][blockY][blockZ]<10)&&(blockX!=chunkWidth-1||terrainGenerator(blockX+1,blockY,blockZ)<10)){
      face[2]=1;
    }else{
      face[2]=0;
    }
    if((blockX==0||blockId[blockX-1][blockY][blockZ]<10)&&(blockX!=0||terrainGenerator(blockX-1,blockY,blockZ)<10)){
      face[3]=1;
    }else{
      face[3]=0;
    }
    if((blockY==chunkHeight-1||blockId[blockX][blockY+1][blockZ]<10)&&(blockY!=chunkHeight-1)){
      face[4]=1;
    }else{
      face[4]=0;
    }
    if(blockY==0||blockId[blockX][blockY-1][blockZ]<10){
      face[5]=1;
    }else{
      face[5]=0;
    }
    setFacesToVBO();
  }
  
  void checkSpecBlocks(){
    if(blockId[blockX][blockY][blockZ]==11&&blockId[blockX][blockY-1][blockZ]>10){
      blockId[blockX][blockY][blockZ]=12;
    }
  }
  
  void setTexTop(){
    if(blockId[blockX][blockY][blockZ]==11){
    texPosX = 0;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==12){
    texPosX = 2;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==13){
    texPosX = 1;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==14){
    texPosX = 5;
    texPosY = 1;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==15){
    texPosX = 5;
    texPosY = 3;
    return;
    }
  }
  
  void setTexSide(){
    if(blockId[blockX][blockY][blockZ]==11){
    texPosX = 3;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==12){
    texPosX = 2;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==13){
    texPosX = 1;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==14){
    texPosX = 4;
    texPosY = 1;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==15){
    texPosX = 5;
    texPosY = 3;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==1){
    texPosX = 7;
    texPosY = 2;
    return;
    }
  }
  
  void setTexBottom(){
    if(blockId[blockX][blockY][blockZ]==11){
    texPosX = 2;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==12){
    texPosX = 2;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==13){
    texPosX = 1;
    texPosY = 0;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==14){
    texPosX = 5;
    texPosY = 1;
    return;
    }
    if(blockId[blockX][blockY][blockZ]==15){
    texPosX = 5;
    texPosY = 3;
    return;
    }
  }
}