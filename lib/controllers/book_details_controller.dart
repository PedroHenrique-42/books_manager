import 'package:book_manager/data/books_repository.dart';
import 'package:book_manager/models/book_model.dart';
import 'package:flutter/foundation.dart';

class BookDetailsController extends ChangeNotifier {
  BookDetailsController({required this.bookId, BooksRepository? repository})
    : _booksRepository = repository ?? BooksRepository();

  final int bookId;
  final BooksRepository _booksRepository;

  BookModel? _book;
  BookModel? get book => _book;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadBook() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _book = await _booksRepository.getBook(bookId);
      if (_book == null) {
        _errorMessage = 'Livro não encontrado.';
      }
    } catch (_) {
      _errorMessage = 'Não foi possível carregar o livro.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteBook() async {
    if (_book?.id == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _booksRepository.deleteBook(_book!.id!);
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível excluir o livro.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
