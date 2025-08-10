import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static const String _geocodingApiKey = 'your-google-maps-api-key'; // Replace with actual API key
  static const String _geocodingBaseUrl = 'https://maps.googleapis.com/maps/api/geocode/json';

  // Check and request location permissions
  static Future<bool> checkPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  // Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        throw Exception('Location permissions not granted');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );

      return position;
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  // Get current position with high accuracy
  static Future<Position?> getCurrentPositionHighAccuracy() async {
    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        throw Exception('Location permissions not granted');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: Duration(seconds: 15),
      );

      return position;
    } catch (e) {
      print('Error getting high accuracy position: $e');
      return null;
    }
  }

  // Get address from coordinates (Reverse Geocoding)
  static Future<String?> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final url = '$_geocodingBaseUrl?latlng=$latitude,$longitude&key=$_geocodingApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          return data['results'][0]['formatted_address'];
        }
      }

      // Fallback to Geolocator's built-in reverse geocoding
      final placemarks = await Geolocator.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return _formatPlacemark(placemark);
      }

      return null;
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return null;
    }
  }

  // Get coordinates from address (Forward Geocoding)
  static Future<Map<String, double>?> getCoordinatesFromAddress(String address) async {
    try {
      final encodedAddress = Uri.encodeComponent(address);
      final url = '$_geocodingBaseUrl?address=$encodedAddress&key=$_geocodingApiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {
            'latitude': location['lat'].toDouble(),
            'longitude': location['lng'].toDouble(),
          };
        }
      }

      // Fallback to Geolocator's built-in geocoding
      final locations = await Geolocator.locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
        };
      }

      return null;
    } catch (e) {
      print('Error getting coordinates from address: $e');
      return null;
    }
  }

  // Get current location with address
  static Future<Map<String, dynamic>?> getCurrentLocationWithAddress() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return null;

      final address = await getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address ?? 'Address not found',
        'accuracy': position.accuracy,
        'timestamp': position.timestamp,
      };
    } catch (e) {
      print('Error getting current location with address: $e');
      return null;
    }
  }

  // Calculate distance between two points
  static double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Calculate bearing between two points
  static double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Check if location is within radius
  static bool isWithinRadius(
    double centerLatitude,
    double centerLongitude,
    double pointLatitude,
    double pointLongitude,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(
      centerLatitude,
      centerLongitude,
      pointLatitude,
      pointLongitude,
    );
    return distance <= radiusInMeters;
  }

  // Get nearby places (mock implementation)
  static Future<List<Map<String, dynamic>>> getNearbyPlaces(
    double latitude,
    double longitude, {
    String type = 'point_of_interest',
    int radius = 1000,
  }) async {
    try {
      // In real implementation, use Google Places API
      await Future.delayed(Duration(seconds: 1)); // Simulate API call

      // Mock nearby places
      return [
        {
          'name': 'Mumbai Municipal Corporation',
          'address': 'CST Road, Mumbai',
          'latitude': latitude + 0.001,
          'longitude': longitude + 0.001,
          'type': 'local_government_office',
          'distance': 150,
        },
        {
          'name': 'Central Park',
          'address': 'Park Street, Mumbai',
          'latitude': latitude - 0.002,
          'longitude': longitude + 0.002,
          'type': 'park',
          'distance': 300,
        },
        {
          'name': 'Community Center',
          'address': 'Main Road, Mumbai',
          'latitude': latitude + 0.003,
          'longitude': longitude - 0.001,
          'type': 'community_center',
          'distance': 450,
        },
      ];
    } catch (e) {
      print('Error getting nearby places: $e');
      return [];
    }
  }

  // Listen to location changes
  static Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    final locationSettings = LocationSettings(
      accuracy: accuracy,
      distanceFilter: distanceFilter,
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // Open location settings
  static Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Open app settings
  static Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  // Format placemark to readable address
  static String _formatPlacemark(Placemark placemark) {
    List<String> addressParts = [];

    if (placemark.street?.isNotEmpty ?? false) {
      addressParts.add(placemark.street!);
    }
    if (placemark.subLocality?.isNotEmpty ?? false) {
      addressParts.add(placemark.subLocality!);
    }
    if (placemark.locality?.isNotEmpty ?? false) {
      addressParts.add(placemark.locality!);
    }
    if (placemark.administrativeArea?.isNotEmpty ?? false) {
      addressParts.add(placemark.administrativeArea!);
    }
    if (placemark.postalCode?.isNotEmpty ?? false) {
      addressParts.add(placemark.postalCode!);
    }
    if (placemark.country?.isNotEmpty ?? false) {
      addressParts.add(placemark.country!);
    }

    return addressParts.join(', ');
  }

  // Get location accuracy description
  static String getAccuracyDescription(double accuracy) {
    if (accuracy <= 5) {
      return 'Very High';
    } else if (accuracy <= 10) {
      return 'High';
    } else if (accuracy <= 20) {
      return 'Medium';
    } else if (accuracy <= 50) {
      return 'Low';
    } else {
      return 'Very Low';
    }
  }

  // Validate coordinates
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  // Get Mumbai-specific locations (for demo purposes)
  static List<Map<String, dynamic>> getMumbaiLandmarks() {
    return [
      {
        'name': 'Gateway of India',
        'latitude': 18.9220,
        'longitude': 72.8347,
        'address': 'Apollo Bandar, Colaba, Mumbai',
      },
      {
        'name': 'Marine Drive',
        'latitude': 18.9441,
        'longitude': 72.8236,
        'address': 'Netaji Subhash Chandra Road, Mumbai',
      },
      {
        'name': 'Chhatrapati Shivaji Terminus',
        'latitude': 18.9401,
        'longitude': 72.8350,
        'address': 'Dr Dadabhai Naoroji Rd, Mumbai',
      },
      {
        'name': 'Bandra-Worli Sea Link',
        'latitude': 19.0348,
        'longitude': 72.8203,
        'address': 'Bandra West, Mumbai',
      },
    ];
  }
}