class Promo
  attr_accessor :target_amount, :discount

  def initialize(target_amount, discount)
    @target_amount = target_amount
    @discount = discount
  end

  def calculate_discount(basket)
    return self.discount if basket.total >= self.target_amount
  end
end
