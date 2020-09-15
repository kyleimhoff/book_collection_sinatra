class UserController < ApplicationController
    get '/users/signup' do 
            erb :'/users/signup'
    end

    post '/users/signup' do 
         @user = User.new(username: params[:username], password: params[:password])
         if @user.save
            session[:id] = @user.id
            redirect "/users/#{@user.id}"  
         else
            erb :'/users/signup'
            
         end

    end

    get '/users/login' do
        
        if !logged_in?
            erb :'/users/login'
        else 
            @user = User.find(session[:id])
            redirect "/users/#{@user.id}"
        end
    end

    post '/users/login' do
        @user = User.find_by(username: params[:username])
        if @user && @user.authenticate(params[:password])
            session[:id] = @user.id
            redirect "/users/#{@user.id}"
        else
            flash[:error] = "Incorrect username or password. Try again"
            erb :"/users/login"
        end
    end

    get '/users/:id' do 
        
        @user = User.find(params[:id])
        erb :'/users/show'
        
    end
    
    delete '/logout' do 
        session.clear 
        redirect '/'
    end
end
