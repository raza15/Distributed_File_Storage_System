class SessionsController < ApplicationController
	def new
		if current_user!=nil
			redirect_to user_path(current_user)
		end

	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.password==params[:session][:password]
			log_in user
			redirect_to user
		else
			flash.now[:danger] = 'Invalid email/password combination'
			render 'new'
		end
	end

	def destroy
		session.delete(:user_id)
    	@current_user = nil
    	redirect_to login_path
	end


end
