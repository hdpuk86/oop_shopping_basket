class Rules
  attr_reader :rules

  def initialize
    @rules = []
  end

  def add(rule)
    @rules.push(rule)
  end

  def remove(rule)
    @rules.delete(rule)
  end

  def multibuy
    self.rules.find_all { |rule| rule.multibuy? }
  end

  def basket
    self.rules.find_all { |rule| rule.basket? }
  end
end
