class PaymentMethod {
  final int id;
  final int userId;
  final String brand; // visa | mastercard | amex
  final String last4;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.brand,
    required this.last4,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      brand: json['brand'].toString(),
      last4: json['last4'].toString(),
    );
  }
}
