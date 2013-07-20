module Temp
	require File.join(File.dirname(__FILE__))+'/LT'
	require File.join(File.dirname(__FILE__))+'/solar'

	#Angular elevation of the sun at which the color temperature
	#transition period starts and ends (in degress).
	#Transition during twilight, and while the sun is lower than
	#3.0 degrees above the horizon.

	TRANSITION_LOW = SOLAR_CIVIL_TWILIGHT_ELEV
	TRANSITION_HIGH = 3.0

	NIGHT_TEMP = 3000 #Kelvin
	DAY_TEMP = 5500 #Kelvin

	def Temp.calculate_interpolated_temperature(elevation, temp_day, temp_night)

		if elevation < TRANSITION_LOW
			#still night
			LT.k2m_i(temp_night)
		elsif elevation < TRANSITION_HIGH
			#Transition period: interpolate
			alpha = (TRANSITION_LOW - elevation) / (TRANSITION_LOW - TRANSITION_HIGH)
			LT.k2m_i( (1.0-alpha)*temp_night + alpha*temp_day)
		else
			#daylight
			LT.k2m_i(temp_day)
		end
	end

end