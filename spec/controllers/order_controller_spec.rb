require 'spec_helper'

describe Spree::OrdersController do
  render_views

  before(:all) do
    @promotion = Spree::Promotion.create(:name => "$10 discount", :code => 'SPREE')
    calculator = Spree::Calculator::FlatRate.new(:preferred_amount => 10)
    action_params = { :promotion => @promotion, :calculator => calculator }
    @action = Spree::Promotion::Actions::CreateAdjustment.create(action_params)

    @shipping_method = Spree::ShippingMethod.new(:name => "UPS Ground")
    @shipping_method.calculator = Spree::Calculator::FlatRate.new(:preferred_amount => 5)
    @shipping_method.save
  end

  after(:all) do
    Spree::ShippingMethod.delete_all
    Spree::Calculator::FlatRate.delete_all
    Spree::Promotion.delete_all
    Spree::Promotion::Actions::CreateAdjustment.delete_all
  end

  before(:each) do
    @order = create(:order)
    @order.contents.add(create(:product, :price => 25).master, 2)
    @order.user = create(:user)
    @order.save
    controller.stub :current_order => @order
    controller.stub :try_spree_current_user => @order.user
  end


  describe "advanced cart" do

    it "should allow get shipping rates by zipcode" do
      create(:shipping_method, :name => "UPS Ground")
      Spree::ShippingMethod.stub :all_available => Spree::ShippingMethod.all
      xhr :get, :estimate_shipping_cost, {:use_route => :spree, :format => :js, :zipcode => "90210"}
      response.should render_template :estimate_shipping_cost
      response.body.should include("UPS Ground")
    end

    # Removed
    xit "should validate zipcode before estimate shipping cost if skip_zipcode_validation is false" do
      Spree::AdvancedCart::Config.set :skip_zipcode_validation => false

      get :estimate_shipping_cost, {:use_route => :spree, :zipcode => "blah-blah-blah"}
      response.should redirect_to('/cart')
      flash[:error].should == I18n.t('estimation_requires_supported_zipcode')
    end

    it "should pass zipcode validation if zipcode is valid and skip_zipcode_validation is false" do
      Spree::AdvancedCart::Config.set :skip_zipcode_validation => false
      create(:shipping_method, :name => "UPS Ground")
      Spree::ShippingMethod.stub :all_available => Spree::ShippingMethod.all

      get :estimate_shipping_cost, {:use_route => :spree, :zipcode => "90210"}
      response.should redirect_to('/cart')
      flash[:notice].should include("UPS Ground")
      flash[:error].should be_nil
    end

    it "should allow enter coupon code in the cart" do
      put :update, {:use_route => :spree, :format => :js, :order => {:coupon_code => 'SPREE'}}
      response.body.should include("Promotion (#{@promotion.name})")
      response.body.should include("-$10.00")
    end

  end

end
