module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def current_user
		if @current_user.nil?
		  @current_user = User.find_by(id: session[:user_id])
		else
		  @current_user
		end		
	end

	def logged_in?
		if @current_user==nil
			false
		else
			true
		end
	end

end