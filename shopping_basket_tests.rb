require 'minitest/autorun'

class ShoppingBasketTests < MiniTest::Test
  def test_can_create_checkout
    assert Checkout.new
  end

  def test_checkout_can_have_rules
    rules = []
    co = Checkout.new(rules)
    assert_equal rules, co.rules
  end
end

class Checkout
  attr_accessor :rules

  def initialize(rules=[])
    @rules = rules
  end
end
