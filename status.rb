require "nokogiri"
require "open-uri"
require "colorize"


class Call
  POLL_TIME = ENV['POLL_TIME'] || 60

  attr_accessor :id, :status, :agency, :location
  @@previous_ids = []

  def initialize(status, agency, location)
    self.id = status.split(", ")[0]
    self.status = status
    self.agency = agency
    self.location = location
  end
  
  # Prints the data with color assignments
  def print(color)
    puts status.colorize(color)
    puts agency.colorize(color)
    puts location.colorize(color)
  end

  # Filters the data and assigns a color based on importance
  def filter
    police = ["Police", "Sheriff"]
    fire = ["Fire"]
    special = ["CHILD", "SHOTS", "ACC1", "ACC3", "ACC4", "BACKO"]
    if special.any? { |special| agency.include?(special)}
      print(:light_yellow)
    elsif agency.include?("EMS")
      print(:light_red)
    elsif police.any? { |police| agency.include?(police)}
      print(:light_blue)
    elsif fire.any? { |fire| agency.include?(fire)}
      print(:red)
    else
      print(:white)
    end
  end

  # Fetches data from the source server
  def self.fetch
    Nokogiri::HTML(open("http://hamilton911.discoveregov.com/ajax.php?ts="))
  end
  
  # Parses the data from the source, formats some of the data, creates a new Call object, and then maps the data to variables
  def self.parse
    call_data = fetch
    call_data.css('br').each{ |br| br.replace ", " }
    call_data.css("tbody tr").map do |tr|
      status = tr.css('td')[0].text
      agency = tr.css('td')[1].text
      location = tr.css('td')[2].text.strip
      location.slice! ("View on Map")
      Call.new(status, agency, location)
    end.reverse
  end

  def self.latest
    calls = parse
    new_ids = calls.map(&:id)
    calls.delete_if {|call| @@previous_ids.include? call.id}
    @@previous_ids = new_ids
    calls
  end

  def self.listen
    loop do
      Call.latest.each(&:filter)
      sleep (POLL_TIME.to_i)
    end
  end
end

puts "Welcome to Status\n\n"
Call.listen
