class UsersController < ApplicationController
  get '/myprofile' do
    if logged_in? && current_user
      @user = User.find(session[:user_id])
      erb :'users/show'
    else
      redirect to '/myshows'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/myprofile'
    end
  end

  post '/users/new' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      user1 = User.find_by(:username => params[:username])
      user2 = User.find_by(:email => params[:email])
      if user1 || user2
        #How can we show an error here to let the user know that name is taken?
        redirect to '/signup', locals: {message: "Username/Email address is taken"}
      else
        @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
        @user.save
        session[:user_id] = @user.id
        redirect to '/myshows'
      end
    end
  end

  get '/login' do
   if !logged_in?
     erb :'users/login'
   else
     redirect to '/myshows'
   end
 end

 post '/login' do
   user = User.find_by(:username => params[:username])
   if user && user.authenticate(params[:password])
     session[:user_id] = user.id
     redirect to '/myshows'
   else
     redirect to '/signup'
   end
 end

 get '/logout' do
    if logged_in?
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  delete '/users/:id' do
    if logged_in? && current_user
      @user = User.find(session[:user_id])
      @user.delete
      redirect to '/signup'
    else
      redirect to '/login'
    end
  end
end
