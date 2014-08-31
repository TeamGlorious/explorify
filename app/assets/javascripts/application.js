// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var coordinates = [[37.2,-122.2],[37.3,-121.8],[37.5,-122.1]];

function initialize(){
  // var to define boundary of all coordinates
  var bounds = new google.maps.LatLngBounds();
  var mapOptions = { mapTypeId: google.maps.MapTypeId.TERRAIN };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  // place markers on map & extend zoom boundary
  for (var i = 0; i < coordinates.length; i++){
    var travelPoint = new google.maps.LatLng(coordinates[i][0], coordinates[i][1]);
    var marker = new google.maps.Marker({
      position: travelPoint,
      map: map,
      title:"Travel Point Test"
    });
    bounds.extend(travelPoint); // zoom boundary
  }
  map.fitBounds(bounds); // set center and zoom level
}

// Creates javascript tags and calls initialize function
function loadScript() {
  var script = document.createElement('script');
  var KEY = 'AIzaSyAxM-N66aK2aCq0yhxQrJJZMh-XYcEauUk&';
  script.src = 'https://maps.googleapis.com/maps/api/js?key=' + KEY + 'callback=initialize';
  document.body.appendChild(script);
}

window.onload = loadScript;



