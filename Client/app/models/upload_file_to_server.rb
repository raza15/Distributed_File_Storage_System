class UploadFileToServer < ApplicationRecord
	   mount_uploader :filename, FilenameUploader # Tells rails to use this uploader for this model.

end
