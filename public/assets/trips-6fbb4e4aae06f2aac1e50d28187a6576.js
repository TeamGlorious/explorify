function showPictures(){for(var e=$("#thumbnails"),o=0;o<keyPhotos.length;o++){var a=$(keyPhotos[o]);a.mouseover(function(){$(this).css("cursor","pointer")}),a.click(function(){}),e.append(a)}}function initialize(){var e={mapTypeId:google.maps.MapTypeId.TERRAIN,styles:[{featureType:"landscape",stylers:[{lightness:5},{hue:"#ff001a"},{saturation:-51}]},{featureType:"road.highway",stylers:[{hue:"#ff0011"},{lightness:53}]},{featureType:"poi.park",stylers:[{hue:"#00ff91"}]},{elementType:"labels",stylers:[{lightness:63},{hue:"#ff0000"}]},{featureType:"road",elementType:"labels",stylers:[{visibility:"off"}]}]};map=new google.maps.Map(document.getElementById("map-canvas"),e),bounds=new google.maps.LatLngBounds,plotPoints(),map.fitBounds(bounds),createMarkers(),showPictures();var o=document.getElementById("search-maps");map.controls[google.maps.ControlPosition.TOP].push(o);var a=new google.maps.places.SearchBox(o);google.maps.event.addListener(a,"places_changed",function(){var e=a.getPlaces();travelPoints.push(e[0].geometry.location),clearMarkers(),createMarkers(),map.fitBounds(bounds)})}function clearMarkers(){for(var e=0;e<markers.length;e++)markers[e].setMap(null);markers=[]}function createMarkers(){var e=function(o,a,n){var t=function(){a<o.length&&e(o,a+1,n)};n(o,a,t)};e(travelPoints,0,function(e,o,a){markerImage=new google.maps.MarkerImage("/assets/balloonMarker-773213d99798b72ca074c976a313384b.png"),markerImage.anchor=new google.maps.Point(20,53),setTimeout(function(){if(markers.push(new google.maps.Marker({position:e[o],map:map,draggable:!1,icon:markerImage})),markers[o].setAnimation(google.maps.Animation.BOUNCE),setTimeout(function(){markers[o].setAnimation(null)},1500),markers[o].setTitle(dates[o]),markerInfoWindow(markers[o],o),o>0){new google.maps.Polyline({geodesic:!0,path:[e[o-1],e[o]],strokeColor:"orange",strokeOpacity:.9,strokeWeight:2,map:map})}a()},50)})}function markerInfoWindow(e,o){google.maps.event.addListener(e,"click",function(){infowindow&&infowindow.close(),infowindow=new google.maps.InfoWindow({content:keyPhotos[o]}),infowindow.open(map,e)})}function loadScript(){var e="",o=document.createElement("script");o.src="https://maps.googleapis.com/maps/api/js?key="+e+"&sensor=true&libraries=places&callback=initialize",document.body.appendChild(o)}$(document).on("ready",function(){$(".datepicker").datepicker()});for(var coordinates=[],travelPoints=[],markers=[],infowindow,keyPhotos=[],dates=[],bounds,map,i=0;i<gon.locations.length;i++)keyPhotos.push("<img src='"+gon.locations[i].thumbnail+"'>"),dates.push(gon.locations[i].date_taken.toString().slice(0,-15));var plotPoints=function(){for(var e=0;e<gon.locations.length;e++)travelPoints.push(new google.maps.LatLng(gon.locations[e].lat,gon.locations[e].lng)),bounds.extend(travelPoints[e])};window.onload=loadScript;