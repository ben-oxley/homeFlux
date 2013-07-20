#!/usr/bin/ruby

#LightTemperature module
#Module defined in LT.rb file

module LT 

	def LT.m2k(mired) 
		if mired != 0
			1000000.0/mired
		else
			raise "Mired cannot be 0" 
		end
	end

	def LT.k2m(kelvin)
		if kelvin != 0
			1000000.0/kelvin
		else
			raise "Kelvin cannot be 0"
		end
	end

	def LT.m2k_i(mired) 
		LT.m2k(mired).to_i
	end

	def LT.k2m_i(kelvin)
		LT.k2m(kelvin).to_i
	end

end