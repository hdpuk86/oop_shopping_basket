require 'byebug'
class MultibuyPromo
  TYPE = 'multibuy'.freeze
  attr_reader :promo_price, :promo_item, :number_of_items_needed

  def initialize(promo_item, number_of_items_needed, promo_price)
    @promo_item = promo_item
    @number_of_items_needed = number_of_items_needed
    @promo_price = promo_price
  end

  def calculate_discount(items, _current_total)
    return 0 unless requirements_met?(items)

    total_after_discount(items)
  end

  def requirements_met?(items)
    number_of_promo_items(items) >= self.number_of_items_needed
  end

  def type
    TYPE
  end

  private

  def total_after_discount(items)
    excess_promo_items = number_of_promo_items(items) % self.number_of_items_needed

    number_of_valid_promo_items = number_of_promo_items(items) - excess_promo_items

    number_of_times_to_apply_promo = number_of_valid_promo_items / self.number_of_items_needed

    prediscount_price = promo_item.price * number_of_valid_promo_items

    total_cost_of_valid_promo_items = self.promo_price * number_of_times_to_apply_promo

    prediscount_price - total_cost_of_valid_promo_items
  end

  def number_of_promo_items(items)
    all_promo_items = items.filter { |item| item == self.promo_item }
    all_promo_items.length
  end
end
