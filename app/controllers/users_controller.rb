class UsersController < ApplicationController
  get '/myprofile' do
    if logged_in? && current_user
      @user = User.find(session[:user_id])
      # @all_users = User.all.select{ |user| user != @user}
      # @shows = Show.all.select{ |show| show.user_id == @user.id}
      erb :'users/show', locals: {message: "Please login before viewing this page"}
    else
      redirect to '/myshows'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'users/create_user', locals: {message: "Please sign up before you sign in"}
    else
      # fix this below
      redirect to '/some_link'
    end
  end

# add method for signup post route to ensure duplicate usernames/emails do not exist in the DB
  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      user1 = User.find_by(:username => params[:username])
      user2 = User.find_by(:email => params[:email])
      if user1 || user2
        #How can we show an error here to let the user know that name is taken?
        redirect to '/signup'
      else
        @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
        @user.save
        session[:user_id] = @user.id
        # fix this below
        redirect to '/myshows'
      end
    end
  end

  get '/login' do
   if !logged_in?
     erb :'users/login'
   else
     # fix this below
     redirect to '/myshows'
   end
 end

 post '/login' do
   user = User.find_by(:username => params[:username])
   if user && user.authenticate(params[:password])
     session[:user_id] = user.id
     # fix this below
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

  # get '/users/:id' do
  #   redirect
  # end

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
