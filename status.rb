require "nokogiri"
require "open-uri"


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
  
  def print
    puts status
    puts agency
    puts location
  end

  def self.fetch
    Nokogiri::HTML(open("http://hamilton911.discoveregov.com/ajax.php?ts="))
  end
  
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
      Call.latest.each(&:print)
      sleep (POLL_TIME.to_i)
    end
  end
end

puts "Welcome to Status"
Call.listen
