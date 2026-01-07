class Book {
  final int id;
  final String title;
  final String author;
  final String category;
  final String image;
  final String description;
  final double price;
  final int qty;
  final String year;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.image,
    required this.description,
    required this.price,
    required this.qty,
    required this.year,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: int.parse(json['id'].toString()),
      title: json['title']?.toString().trim() ?? '',
      author: json['author']?.toString().trim() ?? '',
      category: json['category']?.toString().trim() ?? '',
      image: _cleanImage(json['image']),
      description: json['description']?.toString() ?? '',
      price: double.parse(json['price'].toString()),
      qty: int.parse(json['qty'].toString()),
      year: json['year_of_publication']?.toString() ?? '',
    );
  }

  static String _cleanImage(dynamic img) {
    if (img == null) return '';
    return img
        .toString()
        .replaceAll('"', '')
        .replaceAll("'", '')
        .trim();
  }
}
