#!/usr/bin/python

import serial

# cross fingers ?
ser = serial.Serial()
ser.port='/dev/ttyACM0'
ser.baudrate=1200
ser.open(); ser.close();
