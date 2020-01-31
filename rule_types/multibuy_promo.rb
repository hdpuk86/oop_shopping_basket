class MultibuyPromo
  attr_accessor :promo_price, :promo_item, :target_number_of_items

  def initialize(promo_item, target_number_of_items, promo_price)
    @promo_item = promo_item
    @target_number_of_items = target_number_of_items
    @promo_price = promo_price
  end

  def calculate_discount(basket)
    basket.total - total_after_discount(basket)
  end

  private

  def total_after_discount(basket)
    total_cost_of_valid_promo_items(basket) + total_cost_of_exess_promo_items(basket)
  end

  def total_cost_of_valid_promo_items(basket)
    self.promo_price * times_promotion_should_be_applied(basket)
  end

  def times_promotion_should_be_applied(basket)
    number_of_valid_promo_items(basket) / self.target_number_of_items
  end

  def number_of_valid_promo_items(basket)
    total_number_of_promo_items(basket) - excess_promo_items(basket)
  end

  def all_promo_items(basket)
    basket.items.filter { |basket_item| basket_item == self.promo_item }
  end

  def total_number_of_promo_items(basket)
    all_promo_items(basket).length
  end

  def excess_promo_items(basket)
    total_number_of_promo_items(basket) % self.target_number_of_items
  end

  def total_cost_of_exess_promo_items(basket)
    excess_promo_items(basket) * self.promo_item.price
  end
end
