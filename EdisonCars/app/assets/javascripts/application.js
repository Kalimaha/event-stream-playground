// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap
//= require jquery_ujs
//= require turbolinks
//= require_tree .

function buy(model) {
  $.ajax({
    method: 'POST',
    contentType: 'application/json',
    url: '/orders',
    data: JSON.stringify({ "model": model }),
    success: function(data) {
      $('#info').html('Thank you ' + data.customer_name + '! Your new Edison ' + data.name + ' will be delivered on ' + data.delivery_date + '!')
      $('#info_container').css('display', 'block');
    },
    error: function(e) {
      console.log(e);
    }
  })
}
