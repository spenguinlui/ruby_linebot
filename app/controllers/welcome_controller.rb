class WelcomeController < ApplicationController
  protect_from_forgery with: :null_session
  def webhook
    # 物件初始化
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV['line_channel_secret']
      config.channel_token = ENV['line_channel_token']
    }

    # 收到的訊息會以 params[:events] 傳回

    # 加入 token
    reply_token = params['events'][0]['replyToken']

    # 回覆內容
    if params["events"].first["message"]["text"].index('匯率') != nil
      text = get_rate()
      response_message = {
        type: "text",
        text: text || '很可惜，沒抓到匯率'
      }
    else
      response_message = {
        type: "text",
        text: "聽不懂你在說什麼捏"
        # text: params["events"].first["message"]["text"]
      }
    end

    # 回覆
    client.reply_message(reply_token, response_message)
    render json: response_message
  end

  private

  def get_rate
    # 獲得台銀匯率網站 html
    htmlData = RestClient.get('https://rate.bot.com.tw/xrt').body
    response = Nokogiri::HTML(htmlData)

    # 每一列表格 (tr) 資料
    tr = response.xpath('//table/tbody/tr')

    # 抓出匯率資料
    rate_data = []
    tr.each do |t|
      t_rate = {
        'currency_name(幣別)': t.css('td[data-table="幣別"] div .print_show').text.strip,
        'cash_buying(本行現金買入)': t.css('td[data-table="本行現金買入"]')[0].text,
        'cash_selling(本行現金賣出)': t.css('td[data-table="本行現金賣出"]')[0].text,
        'spot_buying(本行即期買入)': t.css('td[data-table="本行即期買入"]')[0].text,
        'spot_selling(本行即期賣出)': t.css('td[data-table="本行即期賣出"]')[0].text
      }
      rate_data << t_rate
    end
    # rate_data
    '我是匯率'
  end
end
