require 'minitest/autorun'

class ShoppingBasketTests < MiniTest::Test
  def setup
    @rules = []
    @co = Checkout.new(@rules)
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
    item = 'item'
    assert @co.scan(item)
  end

  def test_checkout_total_increases_when_item_scanned
    item = 'item'
    @co.scan(item)
    assert_equal 1, @co.total
  end
end

class Checkout
  attr_accessor :rules, :total

  def initialize(rules=[])
    @rules = rules
    @total = 0
  end

  def scan(item)
    self.total += 1
    true
  end
end
