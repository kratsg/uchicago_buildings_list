require 'net/http'
require 'nokogiri'
uri = URI 'http://registrar.uchicago.edu/page/building-abbreviations-addresses'
response = Net::HTTP.get(uri).gsub!(/(\n|\t)/,"")
response_doc = Nokogiri::HTML(response)
data = response_doc.css('.maincontent table tbody tr').map do |row|
  abbr = row.css('td:nth-child(1) h2 strong').text
  data = row.css('td:nth-child(2) h2').text
  name, addr = data.split(",", 2)
  next if addr.nil?
  abbr.strip!
  name.strip!
  addr.strip!
  {name: name, address: addr, abbreviation: abbr}
end

data.compact
