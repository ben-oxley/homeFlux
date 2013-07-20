require './temp'
require 'date'

date = DateTime.now

(0..24).each do |i| 
	elevation = solar_elevation( (DateTime.now + i/24.0) , 51.5, -0.12) 
	temperature = Temp.calculate_interpolated_temperature(elevation, Temp::DAY_TEMP, Temp::NIGHT_TEMP)
	puts "(" + (date+i/24.0).to_s + "; " + elevation.to_s + "; " + temperature.to_s + ")"
end