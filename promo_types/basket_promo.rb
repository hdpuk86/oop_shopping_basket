class BasketPromo
  attr_reader :target_amount, :discount

  def initialize(target_amount, discount)
    @target_amount = target_amount
    @discount = discount
  end

  def calculate_discount(_items, current_total)
    return 0 unless requirements_met?(current_total)

    self.discount
  end

  def requirements_met?(current_total)
    current_total >= self.target_amount
  end
end
