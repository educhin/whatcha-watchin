class ShowsController < ApplicationController
    get '/myshows' do
      if logged_in? && current_user
        erb :'shows/user_shows', locals: {message: "Please login before viewing this page"}
      else
        # fix this below
        redirect to '/login'

      end
    end

    get '/shows/new' do
      if logged_in?
        erb :'shows/add_show'
      else
        redirect to '/login'
      end
    end

    post '/shows' do
      if params[:name] != "" && params[:genre] != ""
        @user = User.find(session[:user_id])
        @show = Show.new(params[:show])
        @show.user_id = @user.id
        @show.save
      else
        redirect to '/shows/new'
      end
      redirect to '/myshows'
    end

    get 'shows/:id/edit' do

    end

    patch '/shows/:id' do

    end

    delete '/shows/:id/delete' do

    end

    get '/shows/:user_slug' do

    end
end
