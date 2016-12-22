class Resume < ApplicationRecord
   attr_accessor :cat
   mount_uploader :attachment, AttachmentUploader # Tells rails to use this uploader for this model.
	def server_one
		ServerOne.find(server_one_id)
	end

	

end
