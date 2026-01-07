import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/book.dart';
import '/core/config/api_config.dart';

class BookService {

  static Future<List<Book>> getRelatedBooks(Book book) async {
    final res = await http.get(
      Uri.parse(
        '${ApiConfig.baseUrl}/get_related_books.php'
            '?category=${Uri.encodeComponent(book.category)}'
            '&author=${Uri.encodeComponent(book.author)}'
            '&book_id=${book.id}',
      ),
    );


    final List data = jsonDecode(res.body);
    return data.map((e) => Book.fromJson(e)).toList();
  }
}
