Table table;
float scaleValue;
float ellipseRadius;
float ellipseRadiusHeatmap;
float ellipseAlpha;
float greenLineAlpha;
float lineX;
float lineXNext;
float lineY;
float lineYNext;
PImage img;
float offsetX;
float offsetY;
int drawMode;
int counter;
int heightCounter;
JSONArray positionValues;
int h;
int w;
PGraphics mapDraw;
PGraphics heatmapDraw;
boolean hasDrawnHeatMap;
int halfWidth;
int indWidth = 50;

void setup()
{
  frameRate(100);
  size (1200,727,P3D);
  mapDraw = createGraphics(1200,727);
  smooth(16);
  heatmapDraw = createGraphics(1200,727);
  heatmapDraw.beginDraw();
  heatmapDraw.fill(250,0,0,ellipseAlpha);
  heatmapDraw.smooth(16);
  heatmapDraw.endDraw();
  mapDraw.smooth(16);

  positionValues = loadJSONArray("position.json");
  scaleValue = 5.5;
  ellipseRadius = 5;
  ellipseRadiusHeatmap = 6;
  ellipseAlpha =20;
  greenLineAlpha = 125;
  offsetX = -608.0;
  offsetY=-21.0;
  drawMode=2;
  h = height;
  w = width;
  halfWidth = w/2;

  img = loadImage("mapSmall2.png");
  counter = 0;
  DrawHeatmap();

}

void draw(){
    if(drawMode == 3){
        background(30);
    }
    else{
        background(img);
    }

    //background(0);
    noStroke();
    fill(255,255,255,255);
    text("Position: "+counter, 10, 30);
    text("fps: "+frameRate, 10, 45);
    DisplayControls();

    if(drawMode == 1){ //Draw animated ellipses on the positions recorded
        fill(250,0,0,255);
          //for(int i=0 ; i<table.getRowCount() ;i++)
          for(int i=0 ; i<counter ;i++)
          {
            JSONObject pos = positionValues.getJSONObject(i);
            float ellipsePosX = offsetX + width/2+pos.getFloat("x")*scaleValue;
            float ellipsePosY =   offsetY + pos.getFloat("z")*scaleValue;
            ellipse(ellipsePosX,height + ellipsePosY*-1, ellipseRadius, ellipseRadius);
          }
          counter ++;
          if(counter == positionValues.size()){
              counter = 0;
          }
    }
    if(drawMode == 0){ //Draw connected lines showing the movement
        mapDraw.beginDraw();
        mapDraw.fill(0,255,0,greenLineAlpha);
        mapDraw.stroke(0,255,0,greenLineAlpha);
        int halfWidth = w/2;
        JSONObject pos;
        JSONObject posNext;
        float ellipsePosX;
        float ellipsePosY;
        if(counter==0){ mapDraw.background(0,0);}

        pos = positionValues.getJSONObject(counter);
        posNext = positionValues.getJSONObject(counter+1);
        lineX = offsetX + halfWidth+pos.getFloat("x")*scaleValue;
        lineXNext = offsetX + halfWidth+posNext.getFloat("x")*scaleValue;
        lineY = offsetY + pos.getFloat("z")*scaleValue;
        lineYNext = offsetY + posNext.getFloat("z")*scaleValue;

        mapDraw.line(lineX,h +lineY*-1,lineXNext,h +lineYNext*-1);

        ellipsePosX = offsetX + halfWidth+pos.getFloat("x")*scaleValue;
        ellipsePosY =   offsetY + pos.getFloat("z")*scaleValue;
        mapDraw.ellipse(ellipsePosX,h + ellipsePosY*-1, ellipseRadius, ellipseRadius);

        counter ++;
        if(counter == positionValues.size()-1){
            counter = 0;
        }

          mapDraw.endDraw();
          image(mapDraw,0,0);
    }

    if(drawMode ==2){ //Heatmap

        image(heatmapDraw,0,0);
    }
    if(drawMode == 3){ //AVG height
        //background(30);
        JSONObject vertPos;
        float heightAvg = 0;
        float highestVal = 0;
        float valCeiling = 50;
        int offset = 100;
        /*
        stroke(#17bebb);
        strokeWeight(6);
        //textSize(26);
        int offset = 100;
        line(halfWidth,offset,halfWidth,h-offset);
        line(halfWidth-indWidth/2,offset,halfWidth+indWidth/2,offset);
        line(halfWidth-indWidth/2,h-offset,halfWidth+indWidth/2,h-offset);
        */
        DrawAvgHeightScale();

//Get an average for the vertical positions in the game
        for(int i=0 ; i<positionValues.size(); i++){
            vertPos = positionValues.getJSONObject(i);
            if(vertPos.getFloat("y")>highestVal && vertPos.getFloat("y") < 1649){
                highestVal = vertPos.getFloat("y");
            }
            heightAvg += vertPos.getFloat("y");
        }

        heightAvg /= positionValues.size();

        strokeWeight(12);
        stroke(#F4CAE0);
        float indicatorHeight = h-(offset+(((h-offset*2)/valCeiling)*heightAvg));
        line(halfWidth-indWidth/2,indicatorHeight,halfWidth+indWidth/2,indicatorHeight);
        text(heightAvg,halfWidth+indWidth/2 + 10,indicatorHeight);

        text((int)valCeiling,(int)halfWidth+indWidth/2 + 10 , (int)offset);
        text("0",(int)halfWidth+indWidth/2 + 10 , h-offset);
        //println("Avg: "+heightAvg);
        heightAvg = 0;
        highestVal = 0;
    }
    if(drawMode == 4){ //AVG height
        //background(30);
        JSONObject vertPos;
        float heightAvg = 0;
        float highestVal = 0;
        float valCeiling = 50;
        int offset = 100;
        DrawAvgHeightScale();


        for(int i=0; i<positionValues.size(); i++){ //calculate highestVal
            vertPos = positionValues.getJSONObject(i);
            if(vertPos.getFloat("y") > highestVal && vertPos.getFloat("y") < 50){
                highestVal = vertPos.getFloat("y");
            }
        }

        strokeWeight(12);
        stroke(#F4CAE0);

        vertPos = positionValues.getJSONObject(heightCounter);

        float indicatorHeight = h-(offset+(((h-offset*2)/highestVal)*vertPos.getFloat("y")));
        //float indicatorHeight = h-(offset+vertPos.getFloat("y"));
        line(halfWidth-indWidth/2,indicatorHeight,halfWidth+indWidth/2,indicatorHeight);
        text(vertPos.getFloat("y"),halfWidth+indWidth/2 + 10,indicatorHeight);

        text((int)highestVal,(int)halfWidth+indWidth/2 + 10 , (int)offset);
        text("0",(int)halfWidth+indWidth/2 + 10 , h-offset);
        //println("Avg: "+heightAvg);
        heightCounter ++ ;
        heightCounter %= positionValues.size();


        //println(positionValues.size());
        //heightAvg = 0;
        //highestVal = 0;
    }

}
void DrawAvgHeightScale(){
    stroke(#17bebb);
    strokeWeight(6);
    //textSize(26);
    int offset = 100;
    line(halfWidth,offset,halfWidth,h-offset);
    line(halfWidth-indWidth/2,offset,halfWidth+indWidth/2,offset);
    line(halfWidth-indWidth/2,h-offset,halfWidth+indWidth/2,h-offset);
}
void DrawHeatmap(){
    heatmapDraw.beginDraw();
    heatmapDraw.noStroke();
    heatmapDraw.fill(255,100,100,ellipseAlpha);
    heatmapDraw.blendMode(ADD);
    JSONObject pos;
    float ellipsePosX;
    float ellipsePosY;
      for(int i=0 ; i<positionValues.size() ;i++)
      {
        pos = positionValues.getJSONObject(i);
        ellipsePosX = offsetX + halfWidth+pos.getFloat("x")*scaleValue;
        ellipsePosY =   offsetY + pos.getFloat("z")*scaleValue;
        heatmapDraw.ellipse(ellipsePosX,h + ellipsePosY*-1, ellipseRadiusHeatmap, ellipseRadiusHeatmap);
      }
      heatmapDraw.endDraw();

      //image(heatmapDraw,0,0);
}
void ReloadHeatmap(){
    heatmapDraw.beginDraw();
    heatmapDraw.background(0,0);
    DrawHeatmap();
    heatmapDraw.endDraw();
}

//make an update and draw
//check if file has changed
//update if it has, dont re read it if not
//load the jason into a data structure inside, so you dont read every fram
