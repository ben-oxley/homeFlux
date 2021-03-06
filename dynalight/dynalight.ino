// BMP-loading example specifically for the TFTLCD Arduino shield.
// If using the breakout board, use the tftbmp.pde sketch instead!
// If using an Arduino Mega, make sure the SD library is configured for
// 'soft' SPI in the file Sd2Card.h.

#include <Adafruit_GFX.h>    // Core graphics library
#include <Adafruit_TFTLCD.h> // Hardware-specific library
#include <SD.h>
#include <TouchScreen.h>
//#include <MemoryFree.h>
#include <PID_v1.h>

#ifndef USE_ADAFRUIT_SHIELD_PINOUT 
 #error "This sketch is intended for use with the TFT LCD Shield. Make sure that USE_ADAFRUIT_SHIELD_PINOUT is #defined in the Adafruit_TFTLCD.h library file."
#endif

// In the SD card, place 24 bit color BMP files (be sure they are 24-bit!)
// There are examples in the sketch folder

#define SD_CS 5 // Card select for shield use

#define FIRMWARE "dynaLight v0.01 Ben Oxley"

#define	BLACK   0x0000
#define	BLUE    0x001F
#define	RED     0xF800
#define	GREEN   0x07E0
#define CYAN    0x07FF
#define MAGENTA 0xF81F
#define YELLOW  0xFFE0
#define WHITE   0xFFFF

/* some RGB color definitions                                                 */
#define Black           0x0000      /*   0,   0,   0 */
#define Navy            0x000F      /*   0,   0, 128 */
#define DarkGreen       0x03E0      /*   0, 128,   0 */
#define DarkCyan        0x03EF      /*   0, 128, 128 */
#define Maroon          0x7800      /* 128,   0,   0 */
#define Purple          0x780F      /* 128,   0, 128 */
#define Olive           0x7BE0      /* 128, 128,   0 */
#define LightGrey       0xC618      /* 192, 192, 192 */
#define DarkGrey        0x7BEF      /* 128, 128, 128 */
#define Blue            0x001F      /*   0,   0, 255 */
#define Green           0x07E0      /*   0, 255,   0 */
#define Cyan            0x07FF      /*   0, 255, 255 */
#define Red             0xF800      /* 255,   0,   0 */
#define Magenta         0xF81F      /* 255,   0, 255 */
#define Yellow          0xFFE0      /* 255, 255,   0 */
#define White           0xFFFF      /* 255, 255, 255 */
#define Orange          0xFD20      /* 255, 165,   0 */
#define GreenYellow     0xAFE5      /* 173, 255,  47 */
#define Pink            0xF81F
#define JJCOLOR         0x1CB6
#define JJORNG          0xFD03

// These are the pins for the shield!
#define YP A1  // must be an analog pin, use "An" notation!
#define XM A2  // must be an analog pin, use "An" notation!
#define YM 7   // can be a digital pin
#define XP 6   // can be a digital pin

#define TS_MINX 0
#define TS_MINY 125
#define TS_MAXX 920
#define TS_MAXY 940

#define MINPRESSURE 10
#define MAXPRESSURE 1000

#define PENRADIUS  10
//int oldcolor, currentcolor;

TouchScreen ts = TouchScreen(XP, YP, XM, YM, 300);

#define LCD_CS A3
#define LCD_CD A2
#define LCD_WR A1
#define LCD_RD A0

Adafruit_TFTLCD tft;
uint8_t         spi_save;

Point p;

int m,h;
long lastseconds;
int last_m;

double wheelval = 0;
int lastwheelval = 0;

//Define Variables we'll be connecting to
double Input, Output;

//Specify the links and initial tuning parameters
PID myPID(&Input, &Output, &wheelval,0.2,0.2,0.0, DIRECT);

void setup()
{
  Serial.begin(9600);
 
  tft.reset();

  //uint16_t identifier = tft.readID();
uint16_t identifier = 0x7575;

  if(identifier == 0x9325) {
    progmemPrintln(PSTR("Found ILI9325 LCD driver"));
  } else if(identifier == 0x9328) {
    progmemPrintln(PSTR("Found ILI9328 LCD driver"));
  } else if(identifier == 0x7575) {
    progmemPrintln(PSTR("Found HX8347G LCD driver"));
  } else {
    progmemPrint(PSTR("Unknown LCD driver chip: "));
    Serial.println(identifier, HEX);
    return;
  }

  tft.begin(identifier);

  progmemPrint(PSTR("Initializing SD card..."));
  if (!SD.begin(SD_CS)) {
    progmemPrintln(PSTR("failed!"));
    return;
  }
  progmemPrintln(PSTR("OK!"));
  spi_save = SPCR;
  tft.setCursor(0, 0);
  tft.fillScreen(BLACK);
  bmpDraw("Arrow.bmp", 0, 0);
  tft.fillScreen(0);
  tft.setRotation(1);
  bmpDraw("UI.bmp", 0, 0);
  tft.setTextSize(2);
  tft.print("Menu");
  myPID.SetMode(AUTOMATIC);
}

void loop()
{
  delay(10);
  printTime();
  //drawcircle();
  checkswipe();
  //drawcircle();
  Input = analogRead(A5)/4;
  if (lastwheelval != wheelval) { 
    lastwheelval = wheelval; 
    polarcoords(105,map(wheelval, 0, 255, -220, 45));
    Serial.print(wheelval); Serial.print(","); Serial.print(Input); Serial.print(","); Serial.println((int)Output); //Serial.print(","); Serial.println(freeMemory());
    //Serial.println(wheelval);
  }
  myPID.Compute();
}
/*
void menu()
{
  tft.fillScreen(0);
  tft.setCursor(0, 0);
  tft.setTextColor(WHITE);
  tft.setTextSize(1);
  boxes();
  tft.setCursor(22, 37);
  tft.print("Day Light Colour");
  tft.setCursor(192, 37);
  tft.print("Night Light Colour");
  tft.setCursor(22, 97);
  tft.print("LDR Settings");
  tft.setCursor(192, 97);
  tft.print("Connection Settings");
  tft.setCursor(22, 157);
  tft.print("Energy Saving");
  tft.setCursor(192, 157);
  tft.print("Return");
  delay(100);
  digitalWrite(13, HIGH);
  Point p = ts.getPoint();
  digitalWrite(13, LOW);
  while (p.z < MINPRESSURE) {
  digitalWrite(13, HIGH);
  delay(10);
  p = ts.getPoint();
  digitalWrite(13, LOW);
  delay(10);
  }
  //area 1
  tft.fillRect(0, 0, 320, 240, BLACK);
  //tft.fillScreen(BLACK);
  //tft.setRotation(1);
  bmpDraw("UI.bmp", 0, 0);
  delay(1000);
  tft.setTextSize(2);
  delay(500);
  tft.print("Menu");
}
*/
void printTime()
{
  String sh,sm;
  long seconds;
  last_m = m;
  seconds = millis();
  m += (seconds - lastseconds)/1000;
  if (last_m != m) {
    if (m >= 60) {
      m = 0;
      h += 1;
    }
    sh = String(h);
    sm = String(m);
    if (h >= 24) {h = 0;}
    if (h<=9) {sh = "0"+String(h);}
    if (m<=9) {sm = "0"+String(m);}
    tft.fillRoundRect(100,95,130,35,5,BLACK);
    tft.setCursor(120, 100);
    tft.setTextColor(WHITE);  tft.setTextSize(3);
    tft.print(sh+":"+sm);
    lastseconds = seconds;
    Input = analogRead(A5)/4;
    myPID.Compute();
    Serial.print(wheelval); Serial.print(","); Serial.print(Input); Serial.print(","); Serial.println((int)Output); //Serial.print(","); Serial.println(freeMemory());
  }
  
}
/*
void drawcircle() 
{
  for (int i = -220; i < 45; i++) {
    polarcoords(105,i);
  }
}
*/
void polarcoords(int radius, int angle)
{
  static int xlast, ylast;
  //if (xlast != 0) tft.fillCircle(xlast, ylast, PENRADIUS, tft.color565(0,55,75));
  int xout, yout;
  xout = cos(2*PI*angle/360)*radius+(tft.width()/2)+5;
  yout = sin(2*PI*angle/360)*radius+(tft.height()/2)+12;
  tft.fillCircle(xout, yout, PENRADIUS, CYAN);
  xlast = xout;
  ylast = yout;
}

void checkswipe()
{
  static int ylast;
  int yup, ydown;
  digitalWrite(13, HIGH);
  p = ts.getPoint();
  digitalWrite(13, LOW);

  // if sharing pins, you'll need to fix the directions of the touchscreen pins
  //pinMode(XP, OUTPUT);
  pinMode(XM, OUTPUT);
  pinMode(YP, OUTPUT);
  //pinMode(YM, OUTPUT);

  // we have some minimum pressure we consider 'valid'
  // pressure of 0 means no pressing!
  
  if (p.z > MINPRESSURE && p.z < MAXPRESSURE) {
    //if(p.x < 300 && p.y > 750) menu();
  //Serial.print(p.x); Serial.print(" "); Serial.println(p.y) ;  
    /*
    Serial.print("X = "); Serial.print(p.x);
    Serial.print("\tY = "); Serial.print(p.y);
    Serial.print("\tPressure = "); Serial.println(p.z);
    */
    // scale from 0->1023 to tft.width
    //p.x = map(p.x, TS_MINX, TS_MAXX, tft.width(), 0);
    //p.y = map(p.y, TS_MINY, TS_MAXY, tft.height(), 0);
    /*
    Serial.print("("); Serial.print(p.x);
    Serial.print(", "); Serial.print(p.y);
    Serial.println(")");
    */
    ylast = p.x;
    delay(10);
    digitalWrite(13, HIGH);
  p = ts.getPoint();
  digitalWrite(13, LOW);
    if((p.x - ylast) < 100) wheelval -= p.x - ylast;
     
   
    if (wheelval > 255) wheelval = 255;
    if (wheelval < 0) wheelval = 0;
    
  }
}

// This function opens a Windows Bitmap (BMP) file and
// displays it at the given coordinates.  It's sped up
// by reading many pixels worth of data at a time
// (rather than pixel by pixel).  Increasing the buffer
// size takes more of the Arduino's precious RAM but
// makes loading a little faster.  20 pixels seems a
// good balance.

#define BUFFPIXEL 10

void bmpDraw(char *filename, int x, int y) {
  File     bmpFile;
  int      bmpWidth, bmpHeight;   // W+H in pixels
  uint8_t  bmpDepth;              // Bit depth (currently must be 24)
  uint32_t bmpImageoffset;        // Start of image data in file
  uint32_t rowSize;               // Not always = bmpWidth; may have padding
  uint8_t  sdbuffer[3*BUFFPIXEL]; // pixel in buffer (R+G+B per pixel)
  uint16_t lcdbuffer[BUFFPIXEL];  // pixel out buffer (16-bit per pixel)
  uint8_t  buffidx = sizeof(sdbuffer); // Current position in sdbuffer
  boolean  goodBmp = false;       // Set to true on valid header parse
  boolean  flip    = true;        // BMP is stored bottom-to-top
  int      w, h, row, col;
  uint8_t  r, g, b;
  uint32_t pos = 0;
  //uint32_t startTime = millis();
  uint8_t  lcdidx = 0;
  boolean  first = true;

  if((x >= tft.width()) || (y >= tft.height())) return;

  Serial.println();
  Serial.print("Loading image '");
  Serial.print(filename);
  Serial.println('\'');
  // Open requested file on SD card
  SPCR = spi_save;
  if ((bmpFile = SD.open(filename)) == NULL) {
    Serial.print("File not found");
    return;
  }

  // Parse BMP header
  if(read16(bmpFile) == 0x4D42) { // BMP signature
    Serial.print(F("File size: ")); Serial.println(read32(bmpFile));
    (void)read32(bmpFile); // Read & ignore creator bytes
    bmpImageoffset = read32(bmpFile); // Start of image data
    Serial.print(F("Image Offset: ")); Serial.println(bmpImageoffset, DEC);
    // Read DIB header
    Serial.print(F("Header size: ")); Serial.println(read32(bmpFile));
    bmpWidth  = read32(bmpFile);
    bmpHeight = read32(bmpFile);
    if(read16(bmpFile) == 1) { // # planes -- must be '1'
      bmpDepth = read16(bmpFile); // bits per pixel
      Serial.print(F("Bit Depth: ")); Serial.println(bmpDepth);
      if((bmpDepth == 24) && (read32(bmpFile) == 0)) { // 0 = uncompressed

        goodBmp = true; // Supported BMP format -- proceed!
        Serial.print(F("Image size: "));
        //Serial.print(bmpWidth);
        //Serial.print('x');
        //Serial.println(bmpHeight);

        // BMP rows are padded (if needed) to 4-byte boundary
        rowSize = (bmpWidth * 3 + 3) & ~3;

        // If bmpHeight is negative, image is in top-down order.
        // This is not canon but has been observed in the wild.
        if(bmpHeight < 0) {
          bmpHeight = -bmpHeight;
          flip      = false;
        }

        // Crop area to be loaded
        w = bmpWidth;
        h = bmpHeight;
        if((x+w-1) >= tft.width())  w = tft.width()  - x;
        if((y+h-1) >= tft.height()) h = tft.height() - y;

        // Set TFT address window to clipped image bounds
        SPCR = 0;
        tft.setAddrWindow(x, y, x+w-1, y+h-1);

        for (row=0; row<h; row++) { // For each scanline...
          // Seek to start of scan line.  It might seem labor-
          // intensive to be doing this on every line, but this
          // method covers a lot of gritty details like cropping
          // and scanline padding.  Also, the seek only takes
          // place if the file position actually needs to change
          // (avoids a lot of cluster math in SD library).
          if(flip) // Bitmap is stored bottom-to-top order (normal BMP)
            pos = bmpImageoffset + (bmpHeight - 1 - row) * rowSize;
          else     // Bitmap is stored top-to-bottom
            pos = bmpImageoffset + row * rowSize;
          SPCR = spi_save;
          if(bmpFile.position() != pos) { // Need seek?
            bmpFile.seek(pos);
            buffidx = sizeof(sdbuffer); // Force buffer reload
          }

          for (col=0; col<w; col++) { // For each column...
            // Time to read more pixel data?
            if (buffidx >= sizeof(sdbuffer)) { // Indeed
              // Push LCD buffer to the display first
              if(lcdidx > 0) {
                SPCR   = 0;
                tft.pushColors(lcdbuffer, lcdidx, first);
                lcdidx = 0;
                first  = false;
              }
              SPCR = spi_save;
              bmpFile.read(sdbuffer, sizeof(sdbuffer));
              buffidx = 0; // Set index to beginning
            }

            // Convert pixel from BMP to TFT format
            b = sdbuffer[buffidx++];
            g = sdbuffer[buffidx++];
            r = sdbuffer[buffidx++];
            lcdbuffer[lcdidx++] = tft.color565(r,g,b);
          } // end pixel
        } // end scanline
        // Write any remaining data to LCD
        if(lcdidx > 0) {
          SPCR = 0;
          tft.pushColors(lcdbuffer, lcdidx, first);
        } 
        //Serial.print(F("Loaded in "));
        //Serial.print(millis() - startTime);
        //Serial.println(" ms");
      } // end goodBmp
    }
  }

  bmpFile.close();
  if(!goodBmp) Serial.println("BMP format not recognized.");
}

// These read 16- and 32-bit types from the SD card file.
// BMP data is stored little-endian, Arduino is little-endian too.
// May need to reverse subscript order if porting elsewhere.

uint16_t read16(File f) {
  uint16_t result;
  ((uint8_t *)&result)[0] = f.read(); // LSB
  ((uint8_t *)&result)[1] = f.read(); // MSB
  return result;
}

uint32_t read32(File f) {
  uint32_t result;
  ((uint8_t *)&result)[0] = f.read(); // LSB
  ((uint8_t *)&result)[1] = f.read();
  ((uint8_t *)&result)[2] = f.read();
  ((uint8_t *)&result)[3] = f.read(); // MSB
  return result;
}

// Copy string from flash to serial port
// Source string MUST be inside a PSTR() declaration!
void progmemPrint(const char *str) {
  char c;
  while(c = pgm_read_byte(str++)) Serial.print(c);
}

// Same as above, with trailing newline
void progmemPrintln(const char *str) {
  progmemPrint(str);
  Serial.println();
}
/*
void boxes() { // redraw the button outline boxes
  tft.drawRect(0, 20, 150, 50, JJCOLOR);
  tft.drawRect(170, 20, 150, 50, JJCOLOR);
  tft.drawRect(0, 80, 150, 50, JJCOLOR);
  tft.drawRect(170, 80, 150, 50, JJCOLOR);
  tft.drawRect(0, 140, 150, 50, JJCOLOR);
  tft.drawRect(170, 140, 150, 50, JJCOLOR);
}*/
