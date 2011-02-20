Given /^a promotion with code "([^"]*)" and "([^"]*)" amount "([^"]*)"$/ do |code, calc_name, amount|
  promotion = Promotion.new(:name => code, :code => code)
  promotion.calculator = "Calculator::#{calc_name}".constantize.new
  promotion.save
  promotion.calculator.preferred_amount = amount.to_f
  promotion.save
end


Given /^a shipping_method with name "([^"]*)" and "([^"]*)" amount "([^"]*)"$/ do |name, calc_name, amount|
  zone = Zone.find_by_name('North America')
  shipping_method = ShippingMethod.new(:name => name, :zone => zone)
  shipping_method.calculator = "Calculator::#{calc_name}".constantize.new
  shipping_method.save
  shipping_method.calculator.preferred_amount = amount.to_f
  shipping_method.save  
end
