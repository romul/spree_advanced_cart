Spree::OrdersController.class_eval do
  require 'zip-code-info'
  
  def update
    @order = current_order
    if @order.update_attributes(params[:order])
      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      
      if @order.coupon_code.present?
        if Spree::Promotion.exists?(:code => @order.coupon_code)
          fire_event('spree.checkout.coupon_code_added', :coupon_code => @order.coupon_code)
        end
      end
      
      respond_with(@order) do |format| 
        format.html { redirect_to cart_path }
        format.js { @order.update!; render }
      end
    else
      respond_with(@order)
    end
  end
  
  def estimate_shipping_cost
    @order = current_order(true)
    # default attributes for stub address
    address_attrs = { :zipcode => params[:zipcode], 
                      :country_id => Spree::Config[:default_country_id] }
    
    zipcode_is_valid = true
    if !Spree::AdvancedCart::Config[:skip_zipcode_validation]
      # validate zipcode and override attributes of stub address    
      if params[:zipcode] =~ /^\d{5}$/ # USA zipcode
        state = state_id_by_zip(params[:zipcode])
        address_attrs.merge!(:state_id => state.try(:id))
      elsif params[:zipcode] =~ /[a-z]\d[a-z]\s?\d[a-z]\d/i # Canadian zipcode
        address_attrs.merge!(:country_id => Spree::Country.find_by_iso('CA').try(:id))
      else
        zipcode_is_valid = false
      end
    end
    
    if zipcode_is_valid
      @order.ship_address = Spree::Address.new(address_attrs)
      @shipping_methods = Spree::ShippingMethod.all_available(@order)    
      @esc_values = @shipping_methods.
                    map {|sm| [sm.name, sm.calculator.compute(@order)]}.
                    select{|sm| sm[1]}. #Can a shipping calculator return nil for the price? 
                    sort_by{|sm| sm[1]} #Mimic default spree_core behavior, preserve asc cost order
                    
    else
      flash[:error] = I18n.t('estimation_requires_supported_zipcode')
    end
    
    respond_with do |format|
      format.html do
        flash[:notice] = @esc_values.collect{|name, price| "#{name} #{price}" }.join("<br />").html_safe if @esc_values.present?
        redirect_to cart_path
      end
      format.js do
        render :action => :estimate_shipping_cost
      end
    end
  end
  
  def state_id_by_zip(zip_code)
    Spree::State.find_by_abbr(ZipCodeInfo.instance.state_for(zip_code))
  end
  
end

