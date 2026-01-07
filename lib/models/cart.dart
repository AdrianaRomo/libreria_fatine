import 'package:flutter/foundation.dart';
import '/models/book.dart';

class CartModel extends ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => _items;

  double get totalPrice =>
      _items.fold(0.0, (total, current) => total + current.price);


  void add(Book book) {
    _items.add(book);
    notifyListeners();
  }

  void remove(Book book) {
    _items.remove(book);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
