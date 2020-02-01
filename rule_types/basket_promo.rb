class BasketPromo
  attr_accessor :target_amount, :discount

  def initialize(target_amount, discount)
    @target_amount = target_amount
    @discount = discount
  end

  def calculate_discount(basket)
    return 0 unless requirements_met?(basket)

    self.discount
  end

  private

  def requirements_met?(basket)
    basket.total >= self.target_amount
  end
end
