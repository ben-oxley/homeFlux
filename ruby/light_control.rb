require 'httparty'
require 'json'

class LightControl
  
  BRIGHTNESS_RANGE = 0..255
  COLOUR_RANGE = 160..500
  
  attr_accessor :current_temp, :current_brightness
  
  def initialize(ip)
    @ip = ip
    reset_lights
  end
  
  def increase_brightness
    if @current_brightness <= 0 
      lights_on
    end
    
    unless @current_brightness >= 255 
      @current_brightness += 10
      update_light_group({:bri => @current_brightness}) 
    end
  end

  def decrease_brightness
    if @current_brightness <= 0 
      lights_off
    else
      lights_on
      @current_brightness -= 10
      update_light_group({:bri => @current_brightness})
    end
  end
  
  def set_brightness(bri)
    if bri == 0
      lights_off
    else
      update_light_group({:bri => bri}) 
    end
    @current_brightness = bri
  end
  
  def decrease_colour_temp
    unless @current_temp <= 160
      @current_temp -= 10
      update_light_group({:ct => @current_temp})
    end
  end

  def increase_colour_temp
    unless @current_temp <= 500
      @current_temp += 10
      update_light_group({:ct => @current_temp})
    end
  end
  
  def set_colour_temp(temp) 
    update_light_group({:ct => temp})
    @current_temp = temp
  end
  
  def lights_off
    update_light_group({:on => false})
  end
  
  def lights_on
    update_light_group({:on => true})
  end
  
  def reset_lights
    params = { "on" => true, 
                "bri" => 120, 
                "ct" => 400, 
                "effect" => "none", 
                "colormode" => "ct" }
                
    update_light_group(params)
    @current_temp = 400
    @current_brightness = 120
  end  
  
  private
  
  def update_light_group(params)
    puts HTTParty.put("http://#{@ip}/api/newdeveloper/groups/0/action", {:body => JSON.generate( params )})
  end
  
end