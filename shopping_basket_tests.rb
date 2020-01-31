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
end

class Checkout
  attr_accessor :rules

  def initialize(rules=[])
    @rules = rules
  end

  def total
    true
  end
end
