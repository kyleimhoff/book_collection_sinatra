class UserController < ApplicationController
    get '/users/signup' do 
            erb :'/users/signup'
    end

    post '/users/signup' do 
        if params[:username] == "" && params[:password] == ""
            redirect '/users/signup'
        else
         @user = User.create(username: params[:username], password: params[:password])
         @user.save
            session[:id] = @user.id
            redirect "/users/#{@user.id}"  
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
            @error = "Incorrect username or password. Try again"
            redirect "/users/login"
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
