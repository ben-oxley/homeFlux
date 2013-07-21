#!/usr/bin/python

import serial
import time

# cross fingers ?
ser = serial.Serial()
ser.port='/dev/ttyACM0'
ser.baudrate=1200
ser.open(); time.sleep(2); ser.close();
