import 'package:flutter/material.dart';

class RegisterBookPage extends StatefulWidget {
  const RegisterBookPage({super.key});

  @override
  State<RegisterBookPage> createState() => _RegisterBookPageState();
}

class _RegisterBookPageState extends State<RegisterBookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('List of Books')),
      body: const Center(child: Text('This is the RegisterBookPage.')),
    );
  }
}
