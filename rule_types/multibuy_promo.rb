class MultibuyPromo
  attr_accessor :promo_price

  def initialize(item, item_target_number, promo_price)
    @item = item
    @item_target_number = item_target_number
    @promo_price = promo_price
  end

  def calculate_discount(basket)
    1
  end
end
