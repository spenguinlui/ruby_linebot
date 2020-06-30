class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session
  def webhook
    puts params["events"].first["message"]["text"]

    # 物件初始化
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token = ENV['line_channel_token']
    }

    # 收到的訊息會以 params[:events] 傳回

    # 加入 token
    reply_token = params['events'][0]['replyToken']

    # 回覆內容
    response_message = {
      type: "text",
      text: params["events"].first["message"]["text"]
    }

    # 回覆
    client.reply_message(reply_token, response_message)
  end
end
