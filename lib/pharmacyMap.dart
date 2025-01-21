import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pharmacy Locator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const PharmacyMap(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PharmacyMap extends StatefulWidget {
  const PharmacyMap({super.key});

  @override
  State<PharmacyMap> createState() => _PharmacyMapState();
}

class _PharmacyMapState extends State<PharmacyMap> {
  late GoogleMapController mapController;
  final Location location = Location();

  final LatLng _initialPosition = const LatLng(8.3608, 80.5033);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  LatLng? _currentLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  String? _distance;
  String? _duration;

  // API Key - Replace with your Google Maps API key
  static const String _apiKey = 'AIzaSyAozTBFN-3wJuLq1ZSFVqOWXobEA5HNttc';

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _showMessage('Location services are required for this app');
          return;
        }
      }

      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showMessage('Location permissions are required for this app');
          return;
        }
      }

      await location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
        distanceFilter: 10,
      );

      _startLocationTracking();
      // Search for nearby hospitals when location is initialized
      _locationSubscription =
          location.onLocationChanged.listen((LocationData locationData) {
        if (locationData.latitude == null || locationData.longitude == null)
          return;

        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          _searchNearbyHospitals();
        });
      });
    } catch (e) {
      _showMessage('Error initializing location: $e');
    }
  }

  void _startLocationTracking() {
    _locationSubscription = location.onLocationChanged.listen(
      (LocationData locationData) {
        if (locationData.latitude == null || locationData.longitude == null)
          return;

        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);
          _updateCurrentLocationMarker();
        });
      },
      onError: (error) {
        _showMessage('Error tracking location: $error');
      },
    );
  }

  void _updateCurrentLocationMarker() {
    _markers.removeWhere(
      (marker) => marker.markerId == const MarkerId('currentLocation'),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
  }

  Future<void> _searchNearbyHospitals() async {
    if (_currentLocation == null) return;

    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&radius=5000' // Search within 5km
        '&type=hospital'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        // Clear existing hospital markers
        _markers.removeWhere(
          (marker) => marker.markerId.value.startsWith('hospital'),
        );

        // Add new hospital markers
        for (var place in data['results']) {
          final location = place['geometry']['location'];
          final name = place['name'];
          final address = place['vicinity'];

          _markers.add(
            Marker(
              markerId: MarkerId('hospital_${place['place_id']}'),
              position: LatLng(location['lat'], location['lng']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
        }

        setState(() {});
      }
    } catch (e) {
      _showMessage('Error finding hospitals: $e');
    }
  }

  Future<void> _getDirectionsToHospital(LatLng destination) async {
    if (_currentLocation == null) return;

    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=${destination.latitude},${destination.longitude}'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        final points = _decodePolyline(
          data['routes'][0]['overview_polyline']['points'],
        );

        final leg = data['routes'][0]['legs'][0];
        setState(() {
          _distance = leg['distance']['text'];
          _duration = leg['duration']['text'];

          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.blue,
              width: 5,
            ),
          );
        });

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            data['routes'][0]['bounds']['southwest']['lat'],
            data['routes'][0]['bounds']['southwest']['lng'],
          ),
          northeast: LatLng(
            data['routes'][0]['bounds']['northeast']['lat'],
            data['routes'][0]['bounds']['northeast']['lng'],
          ),
        );

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }
    } catch (e) {
      _showMessage('Error getting directions');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              final marker = _markers.firstWhere(
                (m) =>
                    m.position == position &&
                    m.markerId.value.startsWith('hospital_'),
                orElse: () => Marker(markerId: MarkerId('default')),
              );
              if (marker != null) {
                _getDirectionsToHospital(marker.position);
              }
            },
          ),
          if (_distance != null && _duration != null)
            Positioned(
              bottom: 96,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'Distance: $_distance\nDuration: $_duration',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              if (_currentLocation != null) {
                mapController.animateCamera(
                  CameraUpdate.newLatLngZoom(_currentLocation!, 15),
                );
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _searchNearbyHospitals,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.local_hospital, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
