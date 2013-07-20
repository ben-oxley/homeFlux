require 'rubygems'
require 'serialport'
require './solar'
require './temp'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
lights = LightControl.new('192.168.1.225')
count = 0

ardunio.start do |response|
  
  # process brightness
  unscaled_bri = response.split(',')[1]
  bri = (unscaled_bri.to_f / 1024.0) * 255.0
  lights.set_brightness(255 - bri.to_i)
  
 
  elevation = solar_elevation(DateTime.now - (count / 24), 51.5, -0.12) 
  temperature = Temp.calculate_interpolated_temperature(elevation, Temp::DAY_TEMP, Temp::NIGHT_TEMP)
  puts "(" + Time.now.to_s + "; " + elevation.to_s + "; " + temperature.to_s + ")"
  
  
  count = 0 if count == 23

end

