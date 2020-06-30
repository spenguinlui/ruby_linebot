class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session
  def webhook
    render json: 'ok'
  end
end
