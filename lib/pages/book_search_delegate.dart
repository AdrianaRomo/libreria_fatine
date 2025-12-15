import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';

class BookSearchDelegate extends SearchDelegate<Book?> {
  final List<Book> books;

  BookSearchDelegate(this.books);

  @override
  String get searchFieldLabel =>
      'Buscar por título, autor o categoría';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = _filterBooks();
    return _buildList(results);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = _filterBooks();
    return _buildList(results);
  }

  List<Book> _filterBooks() {
    final q = query.toLowerCase();

    return books.where((book) {
      return book.title.toLowerCase().contains(q) ||
          book.author.toLowerCase().contains(q) ||
          book.category.toLowerCase().contains(q);
    }).toList();
  }

  Widget _buildList(List<Book> results) {
    if (results.isEmpty) {
      return const Center(child: Text('No se encontraron libros'));
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final book = results[index];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl: book.image,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(book.title),
          subtitle: Text('${book.author} • ${book.category}'),
          onTap: () => close(context, book),
        );
      },
    );
  }
}
