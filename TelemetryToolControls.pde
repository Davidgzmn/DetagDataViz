void keyPressed() { //Controls for moving the visualization around
    if(key == ' '){
        drawMode++;
        drawMode = drawMode % 5;
    }
    if (key == 'w') {
        scaleValue += .5;
    }
    if (key == 's') {
        scaleValue -= .5;
    }
    if (key == 'k') {
        ellipseRadiusHeatmap -=5;
        ReloadHeatmap();
    }
    if (key == 'l') {
        ellipseRadiusHeatmap +=5;
        ReloadHeatmap();
    }
    if (keyCode == RIGHT) {
        offsetX++;
    }
    if (keyCode == LEFT) {
        offsetX--;
    }
    if (keyCode == UP) {
        offsetY++;
    }
    if (keyCode == DOWN) {
        offsetY--;
    }
    if(key == '.'){

        ellipseAlpha += 10;
        ReloadHeatmap();
    }
    if(key == ','){
        ellipseAlpha -= 10;
        ReloadHeatmap();

    }
    if(key == ':'){
        greenLineAlpha += 10;
    }
    if(key == ';'){
        greenLineAlpha -= 10;
    }
    if (key == 'p'){
        println("Scale Value: " + scaleValue);
        println("Offset X: " + offsetX);
        println("Offset Y: " + offsetY);
    }
    if(key == 'u'){
      println(positionValues.size());
    }
    if(key == 'o'){
      counter=0;
      mapDraw.background(0,0,0,255);

    }
    if(key =='q'){
      save("Heatmap.png");
    }
//Framerate controllers
    if (key =='1'){
      frameRate(5);
    }
    if (key =='2'){
      frameRate(10);
    }
    if (key =='3'){
      frameRate(15);
    }
    if (key =='4'){
      frameRate(20);
    }
    if (key =='5'){
      frameRate(25);
    }
    if (key =='6'){
      frameRate(30);
    }
    if (key =='7'){
      frameRate(35);
    }
    if (key =='8'){
      frameRate(40);
    }
    if (key =='9'){
      frameRate(45);
    }
    if (key =='0'){
      frameRate(1);
    }

}
