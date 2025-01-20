// main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LocationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  // Controllers and Services
  late GoogleMapController mapController;
  final Location location = Location();
  final TextEditingController searchController = TextEditingController();

  // Map Related Variables
  final LatLng _initialPosition = const LatLng(8.3608, 80.5033);
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Location Variables
  LatLng? _currentLocation;
  LatLng? _destinationLocation;
  StreamSubscription<LocationData>? _locationSubscription;

  // Route Information
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
    searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  // Initialize location services and permissions
  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      // Check if location services are enabled
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          _showMessage('Location services are required for this app');
          return;
        }
      }

      // Check location permissions
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          _showMessage('Location permissions are required for this app');
          return;
        }
      }

      // Configure location settings for better accuracy
      await location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 1000,
        distanceFilter: 10,
      );

      // Start tracking location
      _startLocationTracking();
    } catch (e) {
      _showMessage('Error initializing location: $e');
    }
  }

  // Start continuous location tracking
  void _startLocationTracking() {
    _locationSubscription = location.onLocationChanged.listen(
      (LocationData locationData) {
        if (locationData.latitude == null || locationData.longitude == null)
          return;

        setState(() {
          _currentLocation =
              LatLng(locationData.latitude!, locationData.longitude!);

          // Update current location marker
          _updateCurrentLocationMarker();

          // Update route if destination exists
          if (_destinationLocation != null) {
            _getDirections();
          }
        });
      },
      onError: (error) {
        _showMessage('Error tracking location: $error');
      },
    );
  }

  // Update the current location marker
  void _updateCurrentLocationMarker() {
    _markers.removeWhere(
      (marker) => marker.markerId == const MarkerId('currentLocation'),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
  }

  // Search for a location
  Future<void> _searchLocation(String query) async {
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(query);

      if (locations.isNotEmpty) {
        setState(() {
          _destinationLocation = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );

          // Add destination marker
          _markers.removeWhere(
            (marker) => marker.markerId == const MarkerId('destination'),
          );

          _markers.add(
            Marker(
              markerId: const MarkerId('destination'),
              position: _destinationLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(title: query),
            ),
          );
        });

        // Get directions if we have current location
        if (_currentLocation != null) {
          await _getDirections();
        }
      }
    } catch (e) {
      _showMessage('Location not found');
    }
  }

  // Get directions between current location and destination
  Future<void> _getDirections() async {
    if (_currentLocation == null || _destinationLocation == null) return;

    final String url = 'https://maps.googleapis.com/maps/api/directions/json'
        '?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&destination=${_destinationLocation!.latitude},${_destinationLocation!.longitude}'
        '&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        // Decode route points
        final points = _decodePolyline(
          data['routes'][0]['overview_polyline']['points'],
        );

        // Get route information
        final leg = data['routes'][0]['legs'][0];
        setState(() {
          _distance = leg['distance']['text'];
          _duration = leg['duration']['text'];

          // Update route line
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.blue,
              width: 5,
              patterns: [
                PatternItem.dash(20),
                PatternItem.gap(10),
              ],
            ),
          );
        });

        // Adjust map view to show the entire route
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

  // Decode Google's polyline encoding
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

  // Show messages to user
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
        title: const Text('Location Tracker'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Google Map
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
          ),

          // Search Bar
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
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
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search location',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => searchController.clear(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    _searchLocation(query);
                  }
                },
              ),
            ),
          ),

          // Route Information
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
                  CameraUpdate.newLatLngZoom(_currentLocation!, 18),
                );
              }
            },
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
