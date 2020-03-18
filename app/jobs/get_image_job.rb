class GetImageJob < ApplicationJob
  queue_as :default

  def perform(*args, expendable)
    puts "job入った"
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument('--headless')
    d = Selenium::WebDriver.for :chrome, options: options
    wait = Selenium::WebDriver::Wait.new(:timeout => 60)

    d.get(expendable.url)
    puts "URL入れた"
    wait.until{ d.find_element(:class, "rakutenLimitedId_ImageMain1-3").displayed? }
    puts "URL入った"
    item_name = d.find_element(:class, "item_name").find_element(:tag_name, 'b').text.match(/\(/).pre_match
    image = d.find_element(:class, "rakutenLimitedId_ImageMain1-3").find_element(:tag_name, 'img').attribute("src")
    max_quantity = d.find_element(:class, 'rItemUnits').find_elements(:tag_name, 'option').length
    if expendable.name.blank?
      expendable.name = item_name
      puts "名前入れた"
    end
    expendable.image = image
    expendable.max_quantity = max_quantity
    expendable.save
    d.get("https://member.id.rakuten.co.jp/rms/nid/logout")
    puts "finishsh"
  end
end
