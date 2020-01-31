require 'minitest/autorun'

class ShoppingBasketTests < MiniTest::Test
  def test_can_create_checkout
    assert Checkout.new
  end
end

class Checkout
end
