require 'active_resource'
class ServerFive < ActiveResource::Base

	#Returns the current format, default is ActiveResource::Formats::XmlFormat.
	def format
	   read_inheritable_attribute(:format) || ActiveResource::Formats[:xml]
	end

	# self.format = :json
	self.site = "http://127.0.0.1:3005/"
end