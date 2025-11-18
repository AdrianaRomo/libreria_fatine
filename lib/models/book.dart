class Book {
  final String title;
  final String author;
  final String image;
  final String price;
  final String category;
  final String format;
  final String description;

  Book({
    required this.title,
    required this.author,
    required this.image,
    required this.price,
    required this.category,
    required this.format,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      image: json['image'] ?? '',
      price: json['price']?.toString() ?? '0',
      category: json['category'] ?? '',
      format: json['format'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
