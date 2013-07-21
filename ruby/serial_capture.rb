class SerialCapture
  
  def initialize
   @settings = { :port_file => '/dev/ttyACM0', #Find the proper one!
      :baud_rate => 9600,
      :data_bits => 8,
      :stop_bits => 1,
      :parity => SerialPort::NONE,
      :wait_time => 1/4.0
    } 
  end
  
  def start(&block)
    
    
    # @arduino = SerialPort.new( @settings[:port_file], 
    #                           @settings[:baud_rate], 
    #                           @settings[:data_bits], 
    #                           @settings[:stop_bits], 
    #                           @settings[:parity])
                              
    SerialPort.open( @settings[:port_file], 
                     @settings[:baud_rate], 
                     @settings[:data_bits], 
                     @settings[:stop_bits], 
                     @settings[:parity]) do |arduino|
                       
                       main_loop(arduino, &block)
                       
                       
                     end

    puts "Ardunio setup with #{@arduino}"
    main_loop(&block)
  end
  
  private
  
  def main_loop(arduino) 
    puts 'above loop'
    loop do
      r = arduino.readline("\r")
      yield r if block_given?
      sleep @settings[:wait_time]
    end
    
  end
end