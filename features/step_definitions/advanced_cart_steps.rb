Given /^a promotion with code "([^"]*)" and "([^"]*)" amount "([^"]*)"$/ do |code, calc_name, amount|
  promotion = Promotion.new(:name => code, :code => code)
  promotion.calculator = "Calculator::#{calc_name}".constantize.new
  promotion.save
  promotion.calculator.preferred_amount = amount.to_f
  promotion.save
end

