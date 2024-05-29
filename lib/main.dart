import 'package:flutter/material.dart';
import 'pagination_without_getx.dart'; // Assuming your PaginationWithoutGetX widget is defined in a separate file

void main() {
  runApp (MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagination Without GetX',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Pagination Without GetX'),
        ),
        body: PaginationWithoutGetX(), // Integrating PaginationWithoutGetX widget here
      ),
    );
  }
}
