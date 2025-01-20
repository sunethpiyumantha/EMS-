// First, add these dependencies to pubspec.yaml:
// firebase_core: ^latest_version
// firebase_database: ^latest_version

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class PatientLocationService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final String patientId; // Unique ID for the patient
  StreamSubscription<LocationData>? _locationSubscription;
  final Location location = Location();

  PatientLocationService({required this.patientId});

  // Initialize location tracking and Firebase
  Future<void> initializeLocationTracking() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    try {
      // Check location services
      serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) {
          throw Exception('Location services are disabled');
        }
      }

      // Check permissions
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          throw Exception('Location permission denied');
        }
      }

      // Configure location settings
      await location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 5000, // Update every 5 seconds
        distanceFilter: 10, // Minimum movement in meters
      );

      // Start tracking
      startLocationUpdates();
    } catch (e) {
      print('Error initializing location: $e');
      rethrow;
    }
  }

  // Start sending location updates to Firebase
  void startLocationUpdates() {
    _locationSubscription = location.onLocationChanged.listen(
      (LocationData locationData) {
        if (locationData.latitude == null || locationData.longitude == null)
          return;

        // Update location in Firebase
        updateLocationInFirebase(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          heading: locationData.heading ?? 0.0,
          speed: locationData.speed ?? 0.0,
          timestamp: DateTime.now().millisecondsSinceEpoch,
        );
      },
      onError: (error) {
        print('Error tracking location: $error');
      },
    );
  }

  // Update location data in Firebase
  Future<void> updateLocationInFirebase({
    required double latitude,
    required double longitude,
    required double heading,
    required double speed,
    required int timestamp,
  }) async {
    try {
      await _database.child('patient_locations').child(patientId).set({
        'latitude': latitude,
        'longitude': longitude,
        'heading': heading,
        'speed': speed,
        'timestamp': timestamp,
        'status': 'active', // Can be used to track if patient needs assistance
      });
    } catch (e) {
      print('Error updating location in Firebase: $e');
      rethrow;
    }
  }

  // Stop location tracking
  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    // Update status in Firebase
    _database.child('patient_locations').child(patientId).update({
      'status': 'inactive',
    });
  }
}

// Usage in LocationScreen
class _LocationScreenState extends State<LocationScreen> {
  late PatientLocationService _locationService;

  @override
  void initState() {
    super.initState();
    // Initialize with a unique patient ID (you should generate this when patient registers)
    locationService = PatientLocationService(
        patientId: 'patient${DateTime.now().millisecondsSinceEpoch}');
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await Firebase.initializeApp();
      await _locationService.initializeLocationTracking();
    } catch (e) {
      _showMessage('Error initializing services: $e');
    }
  }

  @override
  void dispose() {
    _locationService.stopLocationUpdates();
    super.dispose();
  }
}
