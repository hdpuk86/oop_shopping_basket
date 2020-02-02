class MultibuyPromo
  TYPE = 'multibuy'.freeze
  attr_reader :promo_price, :promo_item, :number_of_items_needed

  def initialize(promo_item, number_of_items_needed, promo_price)
    @promo_item = promo_item
    @number_of_items_needed = number_of_items_needed
    @promo_price = promo_price
  end

  def calculate_discount(items, current_total)
    return 0 unless requirements_met?(items)

    current_total - total_after_discount(items)
  end

  def requirements_met?(items)
    number_of_promo_items(items) >= self.number_of_items_needed
  end

  def type
    TYPE
  end

  private

  def total_after_discount(items)
    non_promo_items = items.filter { |item| item != self.promo_item }
    non_promo_items_cost = non_promo_items.sum { |item| item.price }
    excess_promo_items = number_of_promo_items(items) % self.number_of_items_needed
    number_of_valid_promo_items = number_of_promo_items(items) - excess_promo_items
    number_of_times_to_apply_promo = number_of_valid_promo_items / self.number_of_items_needed
    total_cost_of_valid_promo_items = self.promo_price * number_of_times_to_apply_promo
    total_cost_of_exess_promo_items = excess_promo_items * self.promo_item.price

    total_cost_of_valid_promo_items + total_cost_of_exess_promo_items + non_promo_items_cost
  end

  def number_of_promo_items(items)
    all_promo_items = items.filter { |item| item == self.promo_item }
    all_promo_items.length
  end
end
