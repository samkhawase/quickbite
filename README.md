quickbite
=========

Grab a Quickbite using Openstreetmap API 

The iOS app shows 20 nearest restaurants based on the users current locations. The app fetches the data from the server and shows it on the screen as a list. It's a Master-Detail App and uses MapKit to load the map of the location. It has caching facility with CoreData but it's not completely functional (radius search needs work).  

I'm planning to experiment with the GeoFencing API to improve results. Also in the plans is a way to rate and comment on a place and take notes. The App pulls data from OpenMapquest Nominatim API and uses reverseGeo coding to get location address, until the backend flask app is ready.

