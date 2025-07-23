import processing.sound.*; // Libreria per suoni

PImage duck_hunt_bg; // Sfondo 
PImage erbasovrapposta; // Erba (Punto di generazione delle anatre)
PImage duckhuntlogo; // Logo sulla schermata del titolo
// Da qui iniziano tutti gli sprite delle anatre
PImage anbluang1;
PImage anbluang2;
PImage anbluang3;
PImage anbluang4;
PImage anblulat1;
PImage anblulat2;
PImage anblulat3;
PImage anblulat4;
PImage anbluver1;
PImage anbluver2;
PImage anbluhit;
// Finiscono gli sprite delle anatre
PImage anatracolpita; // Icona che indica che l'anatra è stata colpita, si sostituisce a quella mancata di default
PImage anatramancata; // Icona di default che se non cambia vuol dire che l'anatra è stata mancata
PImage proiettile; // Icona del proiettile

PFont arcade;

int statoGioco=0, roundCounter, semiRoundCounter, colpi, punteggio, controlloSuoni, anatreColpite, statoAnatra1, statoAnatra2;
int durataSemiRound, cooldownPrimoRound; // Interi che usano il tempo, divisi per comodità
float proiettileAttuale;
float timerPreRound, timerAnatre, tempoFugaAnatra1, tempoFugaAnatra2, tempoBattitoAli1, tempoBattitoAli2; // Float che usano il tempo
float xAnatra1, xAnatra2, yAnatra1, yAnatra2; // Float per le anatre
boolean controlloTempoRound, controlloPreRound, anatreAbilitate, battito1, battito2, cambioDirezione1, cambioDirezione2;

SoundFile titlescreen, gunshot, start, youlose, gameover, exit, duckfall, perfect; // Suoni

void setup()
{
  size(1280, 720);
  frameRate(60);
  
  duckhuntlogo=loadImage("immagini/duckhuntlogo.jpg");
  duck_hunt_bg=loadImage("immagini/duck_hunt_bg.jpg");
  erbasovrapposta=loadImage("immagini/erbasovrapposta.jpg");
  anbluang1=loadImage("immagini/anbluang1.png");
  anbluang2=loadImage("immagini/anbluang2.png");
  anbluang3=loadImage("immagini/anbluang3.png");
  anbluang4=loadImage("immagini/anbluang4.png");
  anblulat1=loadImage("immagini/anblulat1.png");
  anblulat2=loadImage("immagini/anblulat2.png");
  anblulat3=loadImage("immagini/anblulat3.png");
  anblulat4=loadImage("immagini/anblulat4.png");
  anbluver1=loadImage("immagini/anbluver1.png");
  anbluver2=loadImage("immagini/anbluver2.png");
  anbluhit=loadImage("immagini/anbluhit.png");
  anatracolpita=loadImage("immagini/anatracolpita.png");
  anatramancata=loadImage("immagini/anatramancata.png");
  proiettile=loadImage("immagini/proiettile.png");
  
  arcade=createFont("arcaden.ttf", 25);
  textFont(arcade);
  
  titlescreen=new SoundFile(this, "suoni/titlescreen.mp3");
  gunshot=new SoundFile(this, "suoni/gunshot.mp3");
  start=new SoundFile(this, "suoni/start.mp3");
  youlose=new SoundFile(this, "suoni/youlose.mp3");
  gameover=new SoundFile(this, "suoni/gameover.mp3");
  exit=new SoundFile(this, "suoni/exit.mp3");
  duckfall=new SoundFile(this, "suoni/duckfall.mp3");
  perfect=new SoundFile(this, "suoni/perfect.mp3");
  
  titlescreen.play();
  
  noCursor();
}

void draw()
{ 
  update();
  
  switch(statoGioco)
  {
   // Schermata del titolo
   case 0:
    background(0);
    image(duckhuntlogo, 280, 20, 720, 350);
    
    text("Premi spazio per iniziare", 335, 450);
    text("1984 NINTENDO", 480, 640);
    
    // Inizializzazione variabili nello stato 0, in modo che ogni volta che si apre il gioco/si torna alla schermata del titolo, tutte le variabili sono pronte per ricominciare il gioco
    roundCounter=1;
    semiRoundCounter=0;
    colpi=3;
    punteggio=0;
    controlloSuoni=0;
    anatreColpite=0;
    statoAnatra1=0;
    statoAnatra2=0;
    durataSemiRound=0;
    cooldownPrimoRound=millis();
    proiettileAttuale=215;
    timerPreRound=millis();
    timerAnatre=0;
    tempoFugaAnatra1=0;
    tempoFugaAnatra2=0;
    tempoBattitoAli1=0;
    tempoBattitoAli2=0;
    xAnatra1=0;
    xAnatra2=0;
    yAnatra1=0;
    yAnatra2=0;
    controlloTempoRound=false;
    controlloPreRound=true;
    anatreAbilitate=false;
    battito1=true;
    battito2=true;
    cambioDirezione1=false;
    cambioDirezione2=false;
    
   case 1:
    if(statoGioco==1) // Questo if è utilizzato per evitare dei problemi che si verificavano perché il gioco non divideva bene case 0 e case 1
    {
      cursor(CROSS);
      
      background(duck_hunt_bg);
      
      controlloAnatre();
      
      image(erbasovrapposta, 0, 504);
      
      // Controllo per far visualizzare il riquadro che indica che round è per i primi 3 secondi del round
      if(controlloPreRound)
      {
        if(millis()-timerPreRound<3000)
        {
          rettangoloPreRound();
        }
        else
        {
          controlloPreRound=false;
        }
      }
  
      // Contatore round
      if(roundCounter<10)
      {
        fill(0);
        strokeWeight(0);
        rect(27, 610, 76, 38);
        fill(88, 209, 2);
        textSize(25);
        text("R="+roundCounter, 30, 640);
      }
      else if(roundCounter>10 && roundCounter<100) // Per questioni di simmetria in quanto le cifre diventano due
      {
        fill(0);
        strokeWeight(0);
        rect(27, 610, 100, 38);
        fill(88, 209, 2);
        textSize(25);
        text("R="+roundCounter, 30, 640);  
      }
      else if(roundCounter>=100) // Game over
      {    
        fill(0);
        strokeWeight(2);
        stroke(255);
        rect(540, 150, 200, 80);
        fill(255);
        textSize(20);
        text("GAME OVER", 552, 200);
        controlloSuoni++; // Ho dovuto utilizzare questo metodo per evitare un loop infinito dei suoni
        if(controlloSuoni==1)
        {
          youlose.play();
          delay(2000);
          gameover.play();
        }
        statoAnatra1=3;
        statoAnatra2=3;
      }
    
      // Caricatore 
      fill(0);
      strokeWeight(2);
      stroke(88, 209, 2);
      rect(150, 610, 100, 70);
      fill(56, 126, 156);
      textSize(18);
      text("COLPI", 158, 670);
      for(int i=0; i<colpi; i++)
      {
        if(i==0)
        {
          proiettileAttuale=215;
        }
        image(proiettile, proiettileAttuale, 618);
        proiettileAttuale-=27;
      }
      
      // Punteggio
      fill(0);
      strokeWeight(2);
      stroke(88, 209, 2);
      rect(1050, 610, 200, 70);
      fill(255);
      textSize(18);
      text("PUNTEGGIO", 1087, 670);
      textSize(22);
      text(punteggio, 1065, 642);
  
      // Anatre colpite
      fill(0);
      strokeWeight(2);
      stroke(88, 209, 2);
      rect(400, 610, 500, 70);
      fill(56, 126, 156);
      textSize(25);
      text("ANATRE", 410, 641);
      textSize(15);
      text("Colpisci almeno 6 anatre a round", 410, 670); // Questa scritta non era presente nel gioco originale, ma era presente da una barra puramente estetica. Ho deciso di aggiungere questa scritta per dare un'utilità a quella parte di GUI
      image(anatramancata, 585, 620);
      image(anatramancata, 615, 620);
      image(anatramancata, 645, 620);
      image(anatramancata, 675, 620);
      image(anatramancata, 705, 620);
      image(anatramancata, 735, 620);
      image(anatramancata, 765, 620);
      image(anatramancata, 795, 620);
      image(anatramancata, 825, 620);
      image(anatramancata, 855, 620);
      float xIniziale=586;
      for(int i=0; i<10; i++)
      {
        if(i<anatreColpite)
        {
          image(anatracolpita, xIniziale, 620); 
        }
        else
        {
          image(anatramancata, xIniziale, 620);  
        }
        xIniziale+=30;
      }
    }
  }
}

void update()
{
  // Incremento dei semi round, le 5 parti di un round
  if(controlloTempoRound)
  {
    if(roundCounter==1 && semiRoundCounter==0)
    {
      if(millis()-durataSemiRound>11500) // Al primo round, il primo semi round è più duraturo, in quanto deve attendere la fine del suono di introduzione
      {
        semiRoundCounter++;
        colpi=3;
        durataSemiRound=millis();
        anatreAbilitate=true;
        
        statoAnatra1=0;
        statoAnatra2=0;
      }
    }
    else if(roundCounter>1 && semiRoundCounter==0)
    {
      if(millis()-durataSemiRound>7000) // Il primo semi round di ogni round è più duraturo, questo perché deve introdurre il round con il rettangolo, ed in quel momento non devono generarsi anatre
      {
        semiRoundCounter++;
        colpi=3;
        durataSemiRound=millis();
        
        statoAnatra1=0;
        statoAnatra2=0;
      }
    }
    else if(roundCounter>=1 && semiRoundCounter>0)
    {
      if(millis()-durataSemiRound>4000)
      {
        semiRoundCounter++;
        colpi=3;
        durataSemiRound=millis();
        
        statoAnatra1=0;
        statoAnatra2=0;
      }
    }
  }
  
  // Incremento dei round
  if(semiRoundCounter==5)
  {
    if(anatreColpite>=6)
    {
      if(anatreColpite==10)
      {
        punteggio+=10000;
        perfect.play();
      }
      
      roundCounter++;
      semiRoundCounter=0;
      
      controlloPreRound=true;
      timerPreRound=millis();
      timerAnatre=millis();
      
      anatreColpite=0;
      
      statoAnatra1=0;
      statoAnatra2=0;
    }
    else
    {
      semiRoundCounter=0;
      roundCounter=100;
    }
  }
}
    
void keyPressed()
{
  if(key==' ' && statoGioco==0)
  {
    controlloTempoRound=true;
    durataSemiRound=millis();
    anatreAbilitate=true;
    timerAnatre=millis();
    
    statoGioco=1;
    titlescreen.stop();
    start.play();
  }
  else if(key==' ' && statoGioco==1 && roundCounter>=100)
  {
    youlose.stop();
    gameover.stop();
    statoGioco=0;
    titlescreen.play();
    fill(255);
    textSize(25);
  }
  
  if(key=='r' || key=='R') // Solo per test per arrivare oltre il round 99
  {
    roundCounter++;
  }
  
  if(key==ESC && statoGioco==0) // Nella schermata del titolo, si può uscire direttamente dal gioco
  {
    key=0;
    exit();
  }
  else if(key==ESC && statoGioco==1) // Ritorno alla schermata del titolo
  {
    key=0;
    start.stop();
    youlose.stop();
    gameover.stop();
    exit.play();
    delay(1200);
    statoGioco=0;
    titlescreen.play();
    fill(255);
    textSize(25);
  }
}

void mousePressed()
{
  // Sparo 
  if(mouseButton==LEFT && statoGioco==1 && roundCounter<100 && colpi>0 && controlloPreRound==false)
  {
    if(roundCounter>1 || roundCounter==1 && semiRoundCounter>0)
    {
      colpi--;
      gunshot.play();
    }
    else if(roundCounter==1 && semiRoundCounter==0)
    {
      if(millis()-cooldownPrimoRound>7500)
      {
        colpi--;
        gunshot.play();
      }
    }
    
    // Abbattimento 
    if(mouseX>xAnatra1 && mouseX<xAnatra1+80 && mouseY>yAnatra1 && mouseY<yAnatra1+80 && statoAnatra1==1)
    {
      punteggio+=1000;
      anatreColpite++;
      statoAnatra1=2;
    }
    if(mouseX>xAnatra2 && mouseX<xAnatra2+80 && mouseY>yAnatra2 && mouseY<yAnatra2+80 && statoAnatra2==1)
    {
      punteggio+=1000;
      anatreColpite++;
      statoAnatra2=2;
    }
  }
}

void rettangoloPreRound() // Funzione a parte per far visualizzare il riquadro che indica che round è
{ 
  if(roundCounter<10)
  {
    fill(0);
    strokeWeight(2);
    stroke(255);
    rect(540, 150, 230, 100);
    fill(255);
    textSize(28);
    text("ROUND", 590, 200);
    text(roundCounter, 644, 230);
  }
  else if(roundCounter>=10 && roundCounter<100) // Per questioni di simmetria in quanto le cifre diventano due
  {
    fill(0);
    strokeWeight(2);
    stroke(255);
    rect(540, 150, 230, 100);
    fill(255);
    textSize(28);
    text("ROUND", 590, 200);
    text(roundCounter, 630, 230);
  }
}

void controlloAnatre()
{
  if(anatreAbilitate)
  {
    if(roundCounter==1 && semiRoundCounter==0)
    {
      if(millis()-timerAnatre>7500)
      {
        anatre();
      }
    }
    else if(roundCounter>1 && semiRoundCounter==0)
    {
      if(millis()-timerAnatre>3000)
      {
        anatre();
      }
    }
    else if(roundCounter>=1 && semiRoundCounter>0)
    {
      anatre();
    }
  }
}

void anatre()
{
  if(statoAnatra1==0) // Generazione anatra a sinistra
  {
    xAnatra1=random(300, 550);
    yAnatra1=560;
    statoAnatra1=1;
    tempoFugaAnatra1=millis();
    tempoBattitoAli1=millis();
  }
  else if(statoAnatra1==1) // Gestione e movimento anatra a sinistra
  {
    if(yAnatra1>300) // Fase diagonale
    {
      image(anbluang3, xAnatra1, yAnatra1);
      yAnatra1-=5;
      xAnatra1-=2;
      
      if(millis()-tempoBattitoAli1>20)
      {
        if(battito1)
        {
          image(anbluang4, xAnatra1, yAnatra1);
          battito1=false;
          tempoBattitoAli1=millis();
        }
        else
        {
          image(anbluang3, xAnatra1, yAnatra1);
          battito1=true;
          tempoBattitoAli1=millis();
        }
      }
    }
   
    if(yAnatra1<=300 && yAnatra1>150)
    {
      if(cambioDirezione1)
      {
        image(anblulat4, xAnatra1, yAnatra1);
        yAnatra1--;
        xAnatra1-=4;

        if(millis()-tempoBattitoAli1>20)
        {
          if(battito1)
          {
            image(anblulat3, xAnatra1, yAnatra1);
            battito1=false;
            tempoBattitoAli1=millis();
          }
          else
          {
            image(anblulat4, xAnatra1, yAnatra1);
            battito1=true;
            tempoBattitoAli1=millis();
          }
        }
      }
      else
      {
        image(anblulat2, xAnatra1, yAnatra1);
        yAnatra1-=2;
        xAnatra1+=5;
        
        if(millis()-tempoBattitoAli1>20)
        {
          if(battito1)
          {
            image(anblulat1, xAnatra1, yAnatra1);
            battito1=false;
            tempoBattitoAli1=millis();
          }
          else
          {
            image(anblulat2, xAnatra1, yAnatra1);
            battito1=true;
            tempoBattitoAli1=millis();
          }
        }
        if(xAnatra1>490)
        {
          cambioDirezione1=true;
        }
      }
    }
    
    if(yAnatra1<=150)
    {
      cambioDirezione1=false;
      
      image(anbluver2, xAnatra1, yAnatra1);
      yAnatra1-=5;
      
      if(millis()-tempoBattitoAli1>20)
      {
        if(battito1)
        {
          image(anbluver1, xAnatra1, yAnatra1);
          battito1=false;
          tempoBattitoAli1=millis();
        }
        else
        {
          image(anbluver2, xAnatra1, yAnatra1);
          battito1=true;
          tempoBattitoAli1=millis();
        }
      }
    }
    
    if(millis()-tempoFugaAnatra1>3850)
    {
      statoAnatra1=3;
    }
  }
  else if(statoAnatra1==2) // Abbattimento anatra a sinistra
  {
    image(anbluhit, xAnatra1, yAnatra1);
    duckfall.play();
    statoAnatra1=3;  
  }
  else if(statoAnatra1==3) // Scomparsa/Fuga anatra a sinistra
  {
    // Non fa nulla, proprio per annullare tutto ciò fatto in precedenza
  }
  
  // --------------------------------------------------------------------------------------------------------
  // ------------------------------------------------------------------------------------(Separazione anatre)
  // --------------------------------------------------------------------------------------------------------
  
  if(statoAnatra2==0) // Generazione anatra a destra
  {
    xAnatra2=random(700, 900);
    yAnatra2=560;
    statoAnatra2=1;
    tempoFugaAnatra2=millis();
    tempoBattitoAli2=millis();
  }
  else if(statoAnatra2==1) // Gestione e movimento anatra a destra
  {
    if(yAnatra2>300) // Fase diagonale 
    {
      image(anbluang1, xAnatra2, yAnatra2);
      yAnatra2-=5;
      xAnatra2+=2;
      if(millis()-tempoBattitoAli2>20)
      {
        if(battito2)
        {
          image(anbluang2, xAnatra2, yAnatra2);
          battito2=false;
          tempoBattitoAli2=millis();
        }
        else
        {
          image(anbluang1, xAnatra2, yAnatra2);
          battito2=true;
          tempoBattitoAli2=millis();
        }
      }
    }
    
    if(yAnatra2<=300 && yAnatra2>150)
    {
      if(cambioDirezione2)
      {
        image(anblulat2, xAnatra2, yAnatra2);
        yAnatra2-=2;
        xAnatra2+=4;
        
        if(millis()-tempoBattitoAli2>20)
        {
          if(battito2)
          {
            image(anblulat1, xAnatra2, yAnatra2);
            battito2=false;
            tempoBattitoAli2=millis();
          }
          else
          {
            image(anblulat2, xAnatra2, yAnatra2);
            battito2=true;
            tempoBattitoAli2=millis();
          }
        }
      }
      else
      {
        image(anblulat4, xAnatra2, yAnatra2);
        yAnatra2--;
        xAnatra2-=5;
        
        if(millis()-tempoBattitoAli2>20)
        {
          if(battito2)
          {
            image(anblulat3, xAnatra2, yAnatra2);
            battito2=false;
            tempoBattitoAli2=millis();
          }
          else
          {
            image(anblulat4, xAnatra2, yAnatra2);
            battito2=true;
            tempoBattitoAli2=millis();
          }
        }
        if(xAnatra2<760)
        {
          cambioDirezione2=true;  
        }
      }
    }
    
    if(yAnatra2<=150)
    {
      cambioDirezione2=false;
      
      image(anbluver2, xAnatra2, yAnatra2);
      yAnatra2-=5;
      
      if(millis()-tempoBattitoAli2>20)
      {
        if(battito2)
        {
          image(anbluver1, xAnatra2, yAnatra2);
          battito2=false;
          tempoBattitoAli2=millis();
        }
        else
        {
          image(anbluver2, xAnatra2, yAnatra2);
          battito2=true;
          tempoBattitoAli2=millis();
        }
      }
    }
    
    if(millis()-tempoFugaAnatra2>3850)
    {
      statoAnatra2=3;  
    }
  }
  else if(statoAnatra2==2) //Abbattimento anatra a destra
  {
    image(anbluhit, xAnatra2, yAnatra2);
    duckfall.play();
    statoAnatra2=3;
  }
  else if(statoAnatra2==3) // Scomparsa/Fuga anatra a destra
  {
    // Non fa nulla, proprio per annullare tutto ciò fatto in precedenza  
  }
}
