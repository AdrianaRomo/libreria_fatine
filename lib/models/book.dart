class Book {
  final String title;
  final String author;
  final String image;
  final double price;
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
      title: json['title'],
      author: json['author'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      format: json['format'],
      description: json['format'],
    );
  }
}