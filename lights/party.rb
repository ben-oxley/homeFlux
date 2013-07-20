# Party Script
require 'httparty'
require 'json'
require 'geokit'
require './geokit_config'
require './light_control'
require './lat_and_long'

# t1 = Thread.new do
#   100.times do
#      r = HTTParty.put("http://192.168.1.225/api/newdeveloper/lights/#{Random.rand(1..3)}/state", {:body => JSON.generate({"on" => true, "sat" => Random.rand(255), :transitiontime => 1, "bri" => Random.rand(255),"hue" => 10000, "xy" => [Random.rand(1.0), Random.rand(1.0)]})})
#   end 
# end
# 

#   (160...500).step(20)  do |i|
#      # r = HTTParty.put("http://192.168.1.225/api/newdeveloper/groups/0/action", {:body => JSON.generate({ "sat" => Random.rand(255), :transitiontime => 1, "bri" => Random.rand(255),"hue" => Random.rand(10000), "xy" => [Random.rand(1.0), Random.rand(1.0)]})})
#      puts i
#      sleep 0.3
#      r = HTTParty.put("http://192.168.1.225/api/newdeveloper/groups/0/action", {:body => JSON.generate({ :ct => i })})
#      puts r
#     # sleep 0.5
#      # r = HTTParty.put("http://192.168.1.225/api/newdeveloper/groups/0/action", {:body => JSON.generate({"on" => state, :transitiontime => 1})})
#      # r = HTTParty.put("http://192.168.1.225/api/newdeveloper/groups/0/action", {:body => JSON.generate({"on" => state, :transitiontime => 1})})
#   end
# 
# 
#   (0...255).step(20) do |i| 
#     sleep 0.3
#      r = HTTParty.put("http://192.168.1.225/api/newdeveloper/groups/0/action", {:body => JSON.generate({ :bri => i })})
#   end
# 
# # t1.join
# # t2.join
# 
# 
#     puts "Time elapsed #{Time.now - beginning} seconds"
    








class LightListener
  
end
