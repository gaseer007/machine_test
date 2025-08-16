class CoworkingSpace {
  final String id;
  final String name;
  final String location;
  final String city;
  final double pricePerHour;
  final List<String> images;
  final String description;
  final List<String> amenities;
  final Map<String, String> operatingHours;
  final double latitude;
  final double longitude;

  const CoworkingSpace({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.pricePerHour,
    required this.images,
    required this.description,
    required this.amenities,
    required this.operatingHours,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'city': city,
    'pricePerHour': pricePerHour,
    'images': images,
    'description': description,
    'amenities': amenities,
    'operatingHours': operatingHours,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory CoworkingSpace.fromJson(Map<String, dynamic> json) => CoworkingSpace(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    city: json['city'],
    pricePerHour: json['pricePerHour'].toDouble(),
    images: List<String>.from(json['images']),
    description: json['description'],
    amenities: List<String>.from(json['amenities']),
    operatingHours: Map<String, String>.from(json['operatingHours']),
    latitude: json['latitude'].toDouble(),
    longitude: json['longitude'].toDouble(),
  );
}
