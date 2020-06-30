class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session
  def webhook
    puts params["events"].first["message"]["text"]
    # render json: 'ok'
  end
end
