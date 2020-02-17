class MultibuyPromo
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

  private

  def total_after_discount(items)
    excess_promo_items = number_of_promo_items(items) % self.number_of_items_needed

    number_of_valid_promo_items = number_of_promo_items(items) - excess_promo_items

    number_of_times_to_apply_promo = number_of_valid_promo_items / self.number_of_items_needed

    promo_items_total = promo_item.price * number_of_valid_promo_items

    promo_discount = self.promo_price * number_of_times_to_apply_promo

    promo_items_total - promo_discount
  end

  def number_of_promo_items(items)
    all_promo_items = items.filter { |item| item == self.promo_item }

    all_promo_items.length
  end
end
