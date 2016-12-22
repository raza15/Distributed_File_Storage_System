json.extract! facebook, :id, :email, :fbemail, :fbpass, :created_at, :updated_at
json.url facebook_url(facebook, format: :json)