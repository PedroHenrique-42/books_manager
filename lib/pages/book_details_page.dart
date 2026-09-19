import 'package:flutter/material.dart';

import '../controllers/book_details_controller.dart';

class BookDetailsPage extends StatefulWidget {
  const BookDetailsPage({required this.bookId, super.key});

  final int bookId;

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late final BookDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = BookDetailsController(bookId: widget.bookId)..loadBook();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _deleteBook() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir livro?'),
        content: const Text('Essa ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    if (await _controller.deleteBook() && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detalhes'),
            actions: [
              IconButton(
                onPressed: _controller.book == null || _controller.isLoading
                    ? null
                    : _deleteBook,
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Excluir livro',
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading && _controller.book == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.book == null) {
      return Center(
        child: Text(_controller.errorMessage ?? 'Livro não encontrado.'),
      );
    }

    final book = _controller.book!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 260,
            child: Image.network(
              book.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image_outlined, size: 80),
            ),
          ),
          const SizedBox(height: 24),
          Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(book.author, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Text(book.description),
          if (_controller.errorMessage != null) ...[
            const SizedBox(height: 16),
            Text(_controller.errorMessage!),
          ],
        ],
      ),
    );
  }
}
