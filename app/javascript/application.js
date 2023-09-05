// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

function initMap(coordsPolygon) {
  var mapElement = document.getElementById('map');
	if (mapElement == null) {
		return;
	}

  var coordsPolygon = mapElement.dataset.coordsPolygon;
  var polygon_points = JSON.parse(coordsPolygon).map(function (lat_lng) {
    return {
      "lat": lat_lng[0],
      "lng": lat_lng[1]
    }
  })

  var map = new google.maps.Map(mapElement, {
    zoom: 8,
    center: polygon_points[0],
  });

  // Create the google maps object
  var map_polygon = new google.maps.Polygon({
        paths: polygon_points,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#FF0000',
        fillOpacity: 0.35
    });

  // Add the polygon to the map
  map_polygon.setMap(map);

  var bounds = new google.maps.LatLngBounds();
  map_polygon.getPath().forEach(function (latLng) {
    bounds.extend(latLng);
  });
  map.fitBounds(bounds);
}

// Access google maps API with the correct API KEY
function loadGoogleMapsAPI() {
  const script = document.createElement('script');
  script.src = `https://maps.googleapis.com/maps/api/js?key=${ENV['GOOGLEAPI']}&callback=initMap`;
  document.head.appendChild(script);
}

document.addEventListener("DOMContentLoaded", function() {
  loadGoogleMapsAPI();
});
window.initMap = initMap;