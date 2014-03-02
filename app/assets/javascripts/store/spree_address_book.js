//= require store/spree_core

(function($) {
  $(document).ready(function(){
	
    $('#checkout_form_address').validate()

    if ($(".select_address").length) {
      $('input#order_use_billing').unbind("click");
      $(".inner").hide();
      $(".inner input").prop("disabled", true);
      $(".inner select").prop("disabled", true);
      if ($('input#order_use_billing').is(':checked')) {
        $("#shipping .select_address").hide();
      }
      
      $('input#order_use_billing').click(function() {
        if ($(this).is(':checked')) {
          $("#shipping .select_address").hide();
					$("input[name='order[ship_address_id]']").attr("checked", false)
          hide_address_form('shipping');
        } else {
          $("#shipping .select_address").show();
					if (parseInt($("#shipping .address-size").html()) == 0 || $("#order_ship_address_attributes_address1").val()) {
						$("#order_ship_address_id_0").attr("checked", true)
						show_address_form('shipping');
					} else {
						$("input[name='order[ship_address_id]']:first").attr("checked", true)
						$("input[name='order[ship_address_id]']:first").trigger("change")
						hide_address_form('shipping');
					}
        }
      });

      $("input[name='order[bill_address_id]']:radio").click(function(){
        if ($("input[name='order[bill_address_id]']:checked").val() == '0') {
          show_address_form('billing');
        } else {
          hide_address_form('billing');
        }
      });

      $("input[name='order[ship_address_id]']:radio").click(function(){
        if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
          show_address_form('shipping');
        } else {
          hide_address_form('shipping');
        }
      });
    }

		$('.capslock input').keyup(function() {
		    this.value = this.value.toLocaleUpperCase();
		});
		
		$("input.fetch_address").change(function(){
			fetch_address($(this).val(), $(this).attr("id"));
			setTimeout(function() { $(".address-book-loader").remove(); }, 1000);
    });

  });
  
  function hide_address_form(address_type){
    $("#" + address_type + " .inner").hide();
    $("#" + address_type + " .inner input").prop("disabled", true);
    $("#" + address_type + " .inner select").prop("disabled", true);
  }
  
  function show_address_form(address_type){
    $("#" + address_type + " .inner").show();
    $("#" + address_type + " .inner input").prop("disabled", false);
    $("#" + address_type + " .inner select").prop("disabled", false);
    $("#order_" + address_type.substring(0,4) + "_address_attributes_zipcode").trigger("change");
  }

  function fetch_address(zipcode, zipcode_field){
		$.ajax({
			type: "POST",
			dataType: "script",
			url: $("#fetch_address_url").data("url"), 
			data: { zipcode: zipcode, zipcode_field: zipcode_field }, 
			beforeSend: function(jqXHR) {
	    	$('<img src="/assets/spinner.gif" alt="loading..." class="address-book-loader">').insertAfter("#" + zipcode_field);
	  	}
		});
  }

})(jQuery);
