class SessionsController < Devise::SessionsController
  respond_to :json
  def create
    Rails.logger.debug("(SessionsController.create) ******* ")
    user = warden.authenticate!(:scope => :user, :recall => "#{controller_path}#failure")
    Rails.logger.debug("(SessionsController.create) back from warden.authenticate ")
  	render :status => 200,
  	  :json => { :success => true,
  	  	         :info => "Logged in",
  	  	         :user => current_user
  	  }
  end

  def destroy
  	warden.authenticate!(:scope => :user, :recall => "#{controller_path}#failure")
  	sign_out
  	render :status => 200,
  	       :json => { :success => true,
  	       	          :info => "Logged out",
  	       }
  end

  def failure
    Rails.logger.debug("SessionsController **failure***")
  	render :status => 401,
  	       :json => { :success => false,
  	       	          :info => "Login Credentials Failed"
  	       }
  end

  def show_current_user
  	warden.authenticate!(:scope => :user, :recall => "#{controller_path}#failure")
  	render :status => 200,
  	       :json => { :success => true,
  	       	          :info => "Current User",
  	       	          :user => current_user

  	       }
  end
end