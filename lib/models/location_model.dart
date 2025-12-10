class LocationModel {
  final int id;
  final double lat;
  final double lng;
  final String? name;
  final bool isDefault;

  LocationModel({
    required this.id,
    required this.lat,
    required this.lng,
    this.name,
    this.isDefault = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: int.parse(json['id'].toString()),
      lat: double.parse(json['lat'].toString()),
      lng: double.parse(json['lng'].toString()),
      name: json['name'],
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "lat": lat,
      "lng": lng,
      "name": name,
      "is_default": isDefault,
    };
  }
}
