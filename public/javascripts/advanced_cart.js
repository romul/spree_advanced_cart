(function($){
  $(document).ready(function(){

    $('#estimate_shipping_costs form').bind('ajax:before', function() {
     $(this).children("input[type=submit]").fadeOut();
     $(this).children(".ajax_loader").show();
    });

    $('#estimate_shipping_costs form').bind('ajax:success', function() {
     $(this).children(".ajax_loader").fadeOut();
     $(this).children("input[type=submit]").show();
    });

    $('form#updatecart').live('ajax:before', function() {
     $("#order_submit").fadeOut();
     $("#applying_coupon").children(".ajax_loader").show();
    });

  });
})(jQuery);

