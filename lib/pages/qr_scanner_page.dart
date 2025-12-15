import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book_detail.dart';
import '/models/book.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  bool scanned = false;

  Future<Book?> fetchBookById(String id) async {
    final url = Uri.parse("http://192.168.1.35/api/query_book.php?id=$id");

    final res = await http.get(url);

    print("URL: $url");
    print("STATUS: ${res.statusCode}");
    print("BODY: ${res.body}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        return Book.fromJson(data["book"]);
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escanear Libro",style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.yellow[700],
        foregroundColor: Colors.black,
        elevation: 2,
      ),
      body: MobileScanner(
        onDetect: (capture) async {
          if (scanned) return;
          scanned = true;

          final barcode = capture.barcodes.first.rawValue;
          if (barcode == null) return;

          final book = await fetchBookById(barcode);

          if (!mounted) return;

          if (book != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BookDetailPage(book: book),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Libro no encontrado")),
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}