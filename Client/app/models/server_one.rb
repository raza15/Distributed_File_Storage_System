require 'active_resource'
require 'uri'
class ServerOne < ActiveResource::Base

	#Returns the current format, default is ActiveResource::Formats::XmlFormat.
	def format
	   read_inheritable_attribute(:format) || ActiveResource::Formats[:xml]
	end

	line_num=0
	text=File.open('ngrok_public_links_of_servers.txt').read
	text.gsub!(/\r\n?/, "\n")
	result = ""
	text.each_line do |line|
	  # print line_num, line
	  if line_num==0 then 
	  	result = ""+line
	  end
	  line_num = line_num+1
	end

	self.site = URI.parse(URI.encode(result.split[0]))

	# self.format = :json
	# self.site = "http://127.0.0.1:3010/"
	# self.site = "http://df851ac0.ngrok.io"
	# def accept_connection
	# a=1
	# # @server_ones = ServerOne.all
	# end	
end