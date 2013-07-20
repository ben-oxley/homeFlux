class LatAndLong
  
  attr_accessor :ip, :latitude, :longitude
  
  def get_my_ip
    defined? @ip  
    response = HTTParty.get('http://checkip.dyndns.org')
    @ip = response.parsed_response.match(/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/)[0]
  end

  def get_lat_and_long
    return @ll[0], @ll[1] if defined? @ll
    ip = get_my_ip
    puts response = Geokit::Geocoders::MultiGeocoder.geocode(ip)
    if response.success?
      @ll = response.ll.split(',')
    else
      response = HTTParty.get('http://www.iplocation.net/')
      matchs = response.parsed_response.scan(/\>([\+|\-]*[0-9]+\.[0-9]+)\</)
      @ll = [matchs[0][0], matchs[1][0]]
    end
    @latitude, @longitude = @ll[0], @ll[1]
    return @ll[0], @ll[1]
  end
  
end