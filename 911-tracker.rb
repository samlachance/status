require "nokogiri"
require "open-uri"

class Call
  attr_accessor :status, :agency, :location, :query_status, :query_agency, :query_location
  def initialize  
    @call_data = Nokogiri::HTML(open("http://hamilton911.discoveregov.com/ajax.php?ts=")); nil
    @status = @call_data.css('td')[0].text
    @agency = @call_data.css('td')[1].text
    @location = @call_data.css('td')[2].text.strip
    @location.slice! ("View on Map")
  end

  # Asks the server for its most recent call and then compares it to your record
  def query
    @query_data = Nokogiri::HTML(open("http://hamilton911.discoveregov.com/ajax.php?ts=")); nil
    @query_status = @query_data.css('td')[0].text
    @query_agency = @query_data.css('td')[1].text
    @query_location = @query_data.css('td')[2].text.strip
    @query_location.slice! ("View on Map")

    unless @query_status == @status
      self.update
    end
  end
  
  # Updates the current call information with the information that was obtained from the server
  def update
    @status = @query_status
    @agency = @query_agency
    @location = @query_location

    puts @status
    puts @agency
    puts @location
  end
end

puts "Welcome to Status."
puts "Please enter refresh rate (in seconds): "
refresh_rate = gets
# Creates object from the Call class
puts "Fetching current call..."
call = Call.new

# Prints the current call information that was obtained when the call object was created
puts call.status
puts call.agency
puts call.location

# Checks the server every x seconds for new information
loop do
  call.query
  sleep (refresh_rate.to_i)
end
