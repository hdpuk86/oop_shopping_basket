require 'minitest/autorun'

class ShoppingBasketTests < MiniTest::Test
  def setup
    @rules = []
    @co = Checkout.new(@rules)
    @item_a = Item.new(2)
  end

  def test_can_create_checkout
    assert Checkout.new
  end

  def test_checkout_can_have_rules
    assert_equal @rules, @co.rules
  end

  def test_checkout_has_a_total
    assert @co.total
  end

  def test_checkout_total_starts_at_zero
    assert_equal 0, @co.total
  end

  def test_checkout_can_scan_items
    assert @co.scan(@item_a)
  end

  def test_checkout_total_increases_when_item_scanned
    @co.scan(@item_a)
    assert_equal 2, @co.total
  end

  def test_checkout_total_increases_by_item_price_when_scanned
    @co.scan(@item_a)
    assert_equal @item_a.price, @co.total
  end
end

class Item
  attr_accessor :price

  def initialize(price)
    @price = price
  end
end

class Checkout
  attr_accessor :rules, :total

  def initialize(rules=[])
    @rules = rules
    @total = 0
  end

  def scan(item)
    self.total += item.price
  end
end
