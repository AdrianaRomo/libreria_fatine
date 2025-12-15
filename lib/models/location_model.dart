class LocationModel {
  final int id;
  final String country;
  final String state;
  final String street;
  final int number;
  final int postal;
  final String reference;
  final int uid;
  final bool isDefault;

  LocationModel({
    required this.id,
    required this.country,
    required this.state,
    required this.street,
    required this.number,
    required this.postal,
    required this.reference,
    required this.uid,
    required this.isDefault,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: int.parse(json['id'].toString()),
      country: json['country'],
      state: json['state'],
      street: json['street'],
      number: int.parse(json['number'].toString()),
      postal: int.parse(json['postal'].toString()),
      reference: json['reference'],
      uid: int.parse(json['uid'].toString()),
      isDefault: json['is_default'] == 1 || json['is_default'] == true,
    );
  }
}
