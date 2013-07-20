require 'rubygems'
require 'serialport'
require './serial_capture'
require './light_control'


ardunio = SerialCapture.new
ardunio.start do |response|
  
  puts "chomp #{response.gsub("\n", "")}"
  puts response.split(',')
end

