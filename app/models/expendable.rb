class Expendable < ApplicationRecord
  # mount_uploader :image, ImageUploader
  belongs_to :user
  validates :url, format: { with: /https:\/\/item.rakuten.co.jp\/kenkocom\/.*/ }

  def self.set_buy_quantity(params, c_id)
    expendables_ids = Expendable.where(user_id: c_id).ids
    buy_quantity = {}
    expendables_ids.each do |e|
      if params[:"exp-id-#{e}"] != "0" && params[:"exp-id-#{e}"].present?
        buy_quantity[:"#{e}"] = params[:"exp-id-#{e}"]
      end
    end
    
    # かごに入れる消耗品のIDと個数の組み合わせをハッシュで作る
    return buy_quantity
  end

  def self.e_images
    expendables = Expendable.all
    e_length = expendables.length
    count = 30/e_length
    e_images = []
    index = 0
    while count > index do
      expendables.each do |e|
        e_images << e.image
      end
      index += 1
    end
    return e_images
  end

  def self.set_quantity
    quantity = (5..30).to_a
    index = 7
    14.times do
      quantity << 5 * index
      index += 1
    end
    index = 11
    10.times do
      quantity << 10 * index
      index += 1
    end
    index = 11
    10.times do
      quantity << 20 * index
      index += 1
    end
    return quantity
  end
end



