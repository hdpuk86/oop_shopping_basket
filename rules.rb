class Rules
  attr_reader :promotions

  def initialize
    @promotions = []
  end

  def add(promo)
    @promotions.push(promo)
  end

  def of_type(type)
    self.promotions.find_all { |promo| promo.type == type }
  end
end
