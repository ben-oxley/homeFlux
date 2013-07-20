require 'rubygems'
require 'serialport'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
ardunio.start do |response|
  
  puts response
  
  puts "chomp #{response.chomp}"
end

