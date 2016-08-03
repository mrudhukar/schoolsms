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
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datepicker/core
//= require cocoon
//= require filterrific/filterrific-jquery

// Inspinia Plugins
//= require metisMenu/jquery.metisMenu.js
//= require pace/pace.min.js
//= require slimscroll/jquery.slimscroll.min.js

//= require chosen-jquery
//= require_tree .

$(function() {
  return $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '200px'
  });
});

jQuery(function() {
  return $('.datepicker').datepicker({
    startView: 2,
    format: "dd-mm-yyyy",
    startDate: "11/05/1987"
  });
});
