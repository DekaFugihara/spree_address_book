//= require store/spree_core

(function($) {
  $(document).ready(function(){
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
					if ($("#shipping .address-size").html() == "0") {
						$("input[name='order[ship_address_id]']").attr("checked", true)
					}
          if ($("input[name='order[ship_address_id]']:checked").val() == '0') {
            show_address_form('shipping');
          }
        }
      });

      $("input[name='order[bill_address_id]']:radio").change(function(){
        if ($("input[name='order[bill_address_id]']:checked").val() == '0') {
          show_address_form('billing');
        } else {
          hide_address_form('billing');
        }
      });

      $("input[name='order[ship_address_id]']:radio").change(function(){
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
		
		$(".zipcode.fetch_address input").change(function(){
			bill_address = $(this).attr("id").indexOf('bill_address');
			if (bill_address == -1) {
				type = "ship_address";
			} else {
				type = "bill_address";
			}
			fetch_address($(this).val(), type);
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
  }

  function fetch_address(zipcode, type){
		$.ajax({
			type: "POST",
			dataType: "script",
			url: $("#checkout_form_address").data("url"), 
			data: { zipcode: zipcode, type: type }, 
			beforeSend: function(jqXHR) {
	    	$('<img src="/assets/spinner.gif" alt="loading..." class="address-book-loader">').insertAfter("#order_" + type + "_attributes_zipcode");
	  	}
		});
  }

})(jQuery);
