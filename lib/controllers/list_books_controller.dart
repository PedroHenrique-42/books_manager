import 'package:book_manager/data/books_repository.dart';
import 'package:book_manager/models/book_model.dart';
import 'package:flutter/foundation.dart';

class ListBooksController extends ChangeNotifier {
  ListBooksController({BooksRepository? repository})
    : _booksRepository = repository ?? BooksRepository();

  final List<BookModel> _books = [];
  List<BookModel> get books => List.unmodifiable(_books);

  final BooksRepository _booksRepository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadBooks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _books
        ..clear()
        ..addAll(await _booksRepository.listBooks());
    } catch (_) {
      _errorMessage = 'Não foi possível carregar os livros.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
