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

  def of_type(type)
    self.rules.find_all { |rule| rule.type == type }
  end
end
