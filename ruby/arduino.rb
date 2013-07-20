require 'rubygems'
require 'serialport'
require './lights/light_control'

#We need to find out what port your arduino is on
#and also what the corresponding file is on /dev
#baud_rate must be same as the baud rate set on the Arduino
#with Serial.begin
port_file = '/dev/ttyACM0' #Find the proper one!
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

#create a SerialPort object using each of the bits of information
arduino = SerialPort.new(port_file, baud_rate, data_bits, stop_bits, parity)

wait_time = 1/4.0 #in seconds

#forever?
loop do
  
  # value 1 = wheel position 0 - 255 represents 
  # value 2 = 0 - 1024 light readying (200-900 ish)
  # value 3 = desired intensity of light
  #arduino.write "whateveryouwanttowrite"
  current_line = arduino.readline("\r") #read everything up to '\r'
  puts current_line
  # wait a little bit before we read the next message?
  # I think we want to do something and restart reading immediately
  sleep wait_time
end