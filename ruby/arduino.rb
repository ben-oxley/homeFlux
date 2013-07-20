require 'rubygems'
require 'serialport'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
lights = LightControl.new('192.168.1.225')

ardunio.start do |response|
  
  puts "chomp #{response.gsub("\n", "")}"
  unscaled_bri = response.split(',')[1]
  
  bri = (unscaled_bri / 1024) * 255
  
  lights.set_brightness(bri)
  
end

