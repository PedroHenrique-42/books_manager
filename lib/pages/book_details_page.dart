import 'package:flutter/material.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({super.key});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Books')),
      body: const Center(child: Text('This is the BookDetailsPage.')),
    );
  }
}
