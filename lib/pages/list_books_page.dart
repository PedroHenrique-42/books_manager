import 'package:flutter/material.dart';

import '../controllers/list_books_controller.dart';
import 'book_details_page.dart';
import 'register_book_page.dart';

class ListBooksPage extends StatefulWidget {
  const ListBooksPage({super.key});

  @override
  State<ListBooksPage> createState() => _ListBooksPageState();
}

class _ListBooksPageState extends State<ListBooksPage> {
  late final ListBooksController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ListBooksController()..loadBooks();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openRegisterPage() async {
    final registered = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const RegisterBookPage()),
    );

    if (registered == true) {
      await _controller.loadBooks();
    }
  }

  Future<void> _openDetails(int bookId) async {
    final deleted = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => BookDetailsPage(bookId: bookId)),
    );

    if (deleted == true) {
      await _controller.loadBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Book Manager'),
            actions: [
              IconButton(
                onPressed: _openRegisterPage,
                icon: const Icon(Icons.add),
                tooltip: 'Cadastrar livro',
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading && _controller.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null && _controller.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_controller.errorMessage!),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: _controller.loadBooks,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_controller.books.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nenhum livro cadastrado.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _openRegisterPage,
              icon: const Icon(Icons.add),
              label: const Text('Cadastrar livro'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _controller.books.length,
      itemBuilder: (context, index) {
        final book = _controller.books[index];
        return ListTile(
          title: Text(
            '${book.title} - ${book.author}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            book.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: book.id == null ? null : () => _openDetails(book.id!),
        );
      },
    );
  }
}
