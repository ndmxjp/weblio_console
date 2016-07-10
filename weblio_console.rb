require 'readline'
require 'open-uri'
require 'nokogiri'

weblio_uri = "http://ejje.weblio.jp/content/"

def get_content(uri) 
	charset = nil

	html = open(uri) do |f|
		charset = f.charset
		f.read
	end

	doc = Nokogiri::HTML.parse(html, nil, charset)
	return doc
end

stty_save = `stty -g`.chomp
trap("INT") { system "stty", stty_save; exit }

while buf = Readline.readline("> ", true)

	request_url = weblio_uri + buf
	doc = get_content(request_url)
	ipa_dom = doc.xpath('//*[@id="phoneticEjjeNavi"]/div/span[2]')[0]
	mean_dom = 	doc.xpath('//*[@id="summary"]/div[1]/table/tbody/tr/td[2]')[0]

	if !ipa_dom.nil? then 
		print("ipa  : ", ipa_dom.text, "\n")
	end
	if !mean_dom.nil? then
		print("mean : ", mean_dom.text, "\n")
	end
end
