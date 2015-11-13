require "nokogiri"
require "open-uri"

page = Nokogiri::HTML(open("http://hamilton911.discoveregov.com/ajax.php?ts="))

status = page.css('td')[0].text
agency = page.css('td')[1].text
location = page.css('td')[2].text

if status.include?("Enroute")
  puts "Enroute"
elsif status.include?("Dispatched")
  puts "Dispatched"
elsif status.include?("On Scene")
  puts "On Scene"
else
  puts "idk"
end

if agency.include?("Chattanooga Police")
  agency.slice! "Chattanooga Police Department"
  puts "CPD"
  puts agency
else 
  puts "didn't work"
end



puts location