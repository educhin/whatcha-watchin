class ShowsController < ApplicationController
    get '/myshows' do
      if logged_in? && current_user
        @user = User.find(session[:user_id])
        @all_users = User.all.select{ |user| user != @user}
        @shows = Show.all.select{ |show| show.user_id == @user.id}
        erb :'shows/user_shows', locals: {message: "Please login before viewing this page"}
      else
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
      if params[:show][:name] != "" && params[:show][:genre] != ""
        @user = User.find(session[:user_id])
        @show = Show.new(params[:show])
        @show.user_id = @user.id
        @show.save
        redirect to '/myshows'
      else
        redirect to '/shows/new'
      end

    end

    get '/shows/:id' do
      if logged_in?
        @show = Show.find(params[:id])
        erb :'shows/display_show'
      else
        redirect to '/login'
      end
    end

    get '/shows/:id/edit' do
      if logged_in?
        @show = Show.find(params[:id])
        if @show && @show.user == current_user
          erb :'shows/edit_show'
        else
          redirect to '/myshows'
        end
      else
        redirect to '/login'
      end
    end

    patch '/shows/:id' do
      if logged_in?
        if params[:name] == "" && params[:genre] == ""
          redirect to "/shows/#{params[:id]}/edit"
        else
          @show = Show.find_by_id(params[:id])
          if @show && @show.user == current_user
            if @show.update(params[:show])
              redirect to "/myshows"
            else
              redirect to "/shows/#{@show.id}/edit"
            end
          else
            redirect to '/users/show'
          end
        end
      else
        redirect to '/login'
      end
    end

    delete '/shows/:id' do
      if logged_in?
        @show = Show.find(params[:id])
        if @show && @show.user == current_user
          @show.delete
          redirect to "/myshows"
        else
          redirect to '/myshows'
        end
      else
        redirect to '/login'
      end
    end

    get '/shows/:user_slug/display' do
      @user = User.find_by_slug(params[:user_slug])
      @all_users = User.all.select{ |user| user.slug != @user.slug && user.slug != current_user.slug}
      @shows = Show.all.select{ |show| show.user_id == @user.id}
      erb :'shows/show_by_user'
    end
end
