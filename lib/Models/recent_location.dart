import 'dart:convert';

class RecentLocation {
  final double lat, lng;
  final String description, name;

  RecentLocation(
      {required this.lat,
      required this.lng,
      required this.description,
      required this.name});

  factory RecentLocation.fromJson(Map<String, dynamic> jsonData) {
    return RecentLocation(
        lat: jsonData['lat'],
        lng: jsonData['lng'],
        description: jsonData['description'],
        name: jsonData['name']);
  }

  static Map<String, dynamic> toMap(RecentLocation recentLocation) => {
        'lat': recentLocation.lat,
        'lng': recentLocation.lng,
        'description': recentLocation.description,
        'name': recentLocation.name
      };

  static String encode(List<RecentLocation> recentLocations) => json.encode(
        recentLocations
            .map<Map<String, dynamic>>(
                (recentLocations) => RecentLocation.toMap(recentLocations))
            .toList(),
      );

  static List<RecentLocation> decode(String recentLocations) =>
      (json.decode(recentLocations) as List<dynamic>)
          .map<RecentLocation>((item) => RecentLocation.fromJson(item))
          .toList();
}
