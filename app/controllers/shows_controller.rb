class ShowsController < ApplicationController
    get '/myshows' do
      if logged_in? && current_user
        erb :'shows/user_shows', locals: {message: "Please login before viewing this page"}
      else
        # fix this below
        redirect to '/some_link'
      end
    end
end
