import 'package:flutter/foundation.dart';
import 'package:libreria_fatine/models/book.dart';


class CartModel extends ChangeNotifier {
  final List<Book> _items = [];

  List<Book> get items => _items;

  double get totalPrice =>
      _items.fold(0, (total, current) => total + (int.tryParse(current.price) ?? 0));


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
