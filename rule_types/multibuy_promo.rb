require 'byebug'

class MultibuyPromo
  attr_accessor :promo_price, :promo_item, :number_of_items_needed

  def initialize(promo_item, number_of_items_needed, promo_price)
    @promo_item = promo_item
    @number_of_items_needed = number_of_items_needed
    @promo_price = promo_price
  end

  def calculate_discount(basket)
    return 0 unless requirements_met?(basket)

    basket.total - total_after_discount(basket)
  end

  private

  def requirements_met?(basket)
    number_of_promo_items(basket) >= self.number_of_items_needed
  end

  def total_after_discount(basket)
    excess_promo_items = number_of_promo_items(basket) % self.number_of_items_needed
    number_of_valid_promo_items = number_of_promo_items(basket) - excess_promo_items
    number_of_times_to_apply_promo = number_of_valid_promo_items / self.number_of_items_needed
    total_cost_of_valid_promo_items = self.promo_price * number_of_times_to_apply_promo
    total_cost_of_exess_promo_items = excess_promo_items * self.promo_item.price

    total_cost_of_valid_promo_items + total_cost_of_exess_promo_items
  end

  def number_of_promo_items(basket)
    all_promo_items = basket.items.filter { |basket_item| basket_item == self.promo_item }
    all_promo_items.length
  end
end
