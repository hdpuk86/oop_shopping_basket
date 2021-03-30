class BasketPromo
  attr_reader :target_amount, :discount

  def initialize(target_amount:, discount:)
    @target_amount = target_amount
    @discount = discount
  end

  def calculate_discount(basket)
    return 0 unless requirements_met?(basket.total)

    self.discount
  end

  def requirements_met?(basket_total)
    basket_total >= self.target_amount
  end
end
