require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
    set :method_override, true 
    register Sinatra::Flash
  end

  get "/" do
    erb :welcome
  end

  helpers do 
    

    def current_user 
      User.find_by_id(session[:id])
    end
    
    
    def logged_in?
      !!current_user
    end

    def redirect_if_not_logged_in
      if !logged_in?
        flash[:error] = "You must be logged in to view that page"
        redirect request.referrer || '/users/login'
      end

    end
  end

end
