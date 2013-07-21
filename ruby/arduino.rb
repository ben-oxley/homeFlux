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
  count = 0 if count == 24
  
  puts response
  
  # process brightness
  bri = response.split(',')[2]

  # calculate temperature
  elevation = solar_elevation(DateTime.now + (count / 24.0), 51.5, -0.12) 
  temperature = Temp.calculate_interpolated_temperature(elevation, Temp::DAY_TEMP, Temp::NIGHT_TEMP)
  
  on_state = true
  
  # set the light data
  lights.update_light_group({:on => on_state, :bri => bri.to_i, :ct => temperature.to_i })

  count += 1

end

