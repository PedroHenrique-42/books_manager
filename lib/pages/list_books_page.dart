import 'package:flutter/material.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({super.key});

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Books')),
      body: const Center(child: Text('This is the ListBooksPage.')),
    );
  }
}
