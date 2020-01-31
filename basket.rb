class Basket
  attr_accessor :total, :items

  def initialize
    @total = 0
    @items = []
  end

  def add_item(item)
    self.items << item
    self.total += item.price
  end
end
