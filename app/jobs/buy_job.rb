class BuyJob < ApplicationJob

  def perform(*args, buy_quantity, email, password)
    require 'securerandom'
    require 'Time'
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    options.add_argument('--window-size=4000, 4000')
    d = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 600)

    d.get("https://grp01.id.rakuten.co.jp/rms/nid/vc?__event=login&service_id=top")
    wait.until { d.find_element(:id, "loginInner_u").displayed? }
    d.find_element(:id, "loginInner_u").send_keys(email)
    d.find_element(:id, "loginInner_p").send_keys(password)
    d.find_element(:class, "loginButton").click
    puts "ログイン"
    d.save_screenshot("/Users/handaryouhei/Desktop/#{SecureRandom.hex(16)}.png")
    buy_quantity.each do |id, quantity|
      expendable  = Expendable.find(id.to_s.to_i)
      pastBuy = expendable.lastBuy
      d.save_screenshot("/Users/handaryouhei/Desktop/#{SecureRandom.hex(16)}.png")
      d.get(expendable.url)
      d.save_screenshot("/Users/handaryouhei/Desktop/#{SecureRandom.hex(16)}.png")
      wait.until { d.find_element(:class, "rItemUnits").displayed? }
      Selenium::WebDriver::Support::Select.new(d.find_element(:class, 'rItemUnits')).select_by(:value, quantity)
      d.find_element(:class, 'new-cart-button').click

      d.get("https://www.yahoo.co.jp/")
      wait.until { d.find_element(:class, "rapid-noclick-resp").displayed? }
      expendable.lastBuy = Time.now
      nowBuy = expendable.lastBuy

      if pastBuy.present?
        expendable.quantity = (expendable.quantity.to_f*0.6 + (((nowBuy-pastBuy).to_f/86400)/quantity.to_f)*0.4).to_i

        puts expendable.quantity.to_f
        puts (nowBuy-pastBuy).to_f/86400
        puts expendable.quantity

        expendable.quantity = 1 if expendable.quantity < 1
      end

      expendable.save
    end


    logger.debug "finish"
    d.get("https://member.id.rakuten.co.jp/rms/nid/logout")
  end
end
