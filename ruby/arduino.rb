require 'rubygems'
require 'serialport'
require './solar'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
lights = LightControl.new('192.168.1.225')

ardunio.start do |response|
  
  # process brightness
  unscaled_bri = response.split(',')[1]
  bri = (unscaled_bri.to_f / 1024.0) * 255.0
  lights.set_brightness(255 - bri.to_i)
  
  # check temp
  elevation = solar_elevation( (date+i/24.0) , 51.5, -0.12) 
	temperature = Temp.calculate_interpolated_temperature(elevation, Temp::DAY_TEMP, Temp::NIGHT_TEMP)
	puts "(" + (date+i/24.0).to_s + "; " + elevation.to_s + "; " + temperature.to_s + ")"
  
  
end

