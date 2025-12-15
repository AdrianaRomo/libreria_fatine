import '../models/book.dart';

class UniqueController {
  static final List<Book> _items = [];

  static List<Book> get items => _items;

  static void add(Book book) {
    _items.add(book);
  }

  static void remove(Book book) {
    _items.remove(book);
  }

  static void clear() {
    _items.clear();
  }
}
