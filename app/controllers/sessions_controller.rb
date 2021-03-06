# module Api
class SessionsController < ApiController
  skip_before_action :require_login, only: [:create], raise: false

    def new
    end
  
    def create
      
      if user = User.validate_login(params[:email], params[:password])
        allow_token_to_be_used_only_once_for(user)
        send_token_for_valid_login_of(user)
        flash[:success] = 'You have logged in successfully'
      else
        render_unauthorized ("Invalid Login or Password")
      end
    end
  
    def destroy  
      logout 
      head :ok
    end

    private 

    def send_token_for_valid_login_of(user)
      render json: {token: user.auth_token}
    end 

    def allow_token_to_be_used_only_once_for(user)
      user.regenerate_auth_token
    end 
    
    def logout 
      current_user.invalidate_auth_token
    end 
  end