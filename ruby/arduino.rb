require 'rubygems'
require 'serialport'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
lights = LightControl.new('192.168.1.225')

ardunio.start do |response|
  
  unscaled_bri = response.split(',')[1]
  bri = (unscaled_bri.to_f / 1024.0) * 255.0
  lights.set_brightness(255 - bri.to_i)
  
  
end

