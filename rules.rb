class Rules
  attr_reader :promotions

  def initialize
    @promotions = []
  end

  def add(promo)
    @promotions.push(promo)
  end
end
