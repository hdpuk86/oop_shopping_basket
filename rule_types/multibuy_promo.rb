class MultibuyPromo
  attr_accessor :promo_price, :item, :target_item_number

  def initialize(item, target_item_number, promo_price)
    @item = item
    @target_item_number = target_item_number
    @promo_price = promo_price
  end

  def calculate_discount(basket)
    correct_items = basket.items.filter { |basket_item| basket_item == self.item }
    number_of_correct_items = correct_items.length
    number_of_extra_items = number_of_correct_items % self.target_item_number
    extra_items_cost = number_of_extra_items * self.item.price

    promo_cost = ((number_of_correct_items - number_of_extra_items)/ self.target_item_number) * self.promo_price
    new_total = promo_cost + extra_items_cost
    (number_of_correct_items * self.item.price) - new_total
  end
end
