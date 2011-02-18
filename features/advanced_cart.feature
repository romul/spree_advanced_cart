Feature: AdvancedCart

  @selenium
  Scenario: Add promotion with order's total


    Given a promotion with code "SPREE" and "FlatRate" amount "5"

    When I add a product with name: "RoR Mug", price: "40" to cart
    And I fill in "order_coupon_code" with "SPREE"
    And I press "Apply"
    Then I should see "Coupon (SPREE)"
    And I should see "-$5"

