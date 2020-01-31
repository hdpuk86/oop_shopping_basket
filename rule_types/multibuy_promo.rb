class MultibuyPromo
  attr_accessor :promo_price, :item, :target_item_number

  def initialize(item, target_item_number, promo_price)
    @item = item
    @target_item_number = target_item_number
    @promo_price = promo_price
  end

  def calculate_discount(basket)
    promo_cost = ((number_of_correct_items(basket) - number_of_extra_items(basket))/ self.target_item_number) * self.promo_price
    new_total = promo_cost + cost_of_extra_items(basket)
    (number_of_correct_items(basket) * self.item.price) - new_total
  end

  private

  def correct_items(basket)
    basket.items.filter { |basket_item| basket_item == self.item }
  end

  def number_of_correct_items(basket)
    correct_items(basket).length
  end

  def number_of_extra_items(basket)
    number_of_correct_items(basket) % self.target_item_number
  end

  def cost_of_extra_items(basket)
    number_of_extra_items(basket) * self.item.price
  end
end
