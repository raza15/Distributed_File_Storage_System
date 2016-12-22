json.extract! upload_file_to_server, :id, :email, :filename, :created_at, :updated_at
json.url upload_file_to_server_url(upload_file_to_server, format: :json)