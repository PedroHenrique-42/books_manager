import 'package:book_manager/data/books_repository.dart';
import 'package:book_manager/models/book_model.dart';
import 'package:flutter/foundation.dart';

class RegisterBookController extends ChangeNotifier {
  RegisterBookController({BooksRepository? repository})
    : _booksRepository = repository ?? BooksRepository();

  final BooksRepository _booksRepository;

  String title = '';
  String description = '';
  String author = '';
  String imageUrl = '';

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void updateTitle(String value) {
    title = value;
    notifyListeners();
  }

  void updateDescription(String value) {
    description = value;
    notifyListeners();
  }

  void updateAuthor(String value) {
    author = value;
    notifyListeners();
  }

  void updateImageUrl(String value) {
    imageUrl = value;
    notifyListeners();
  }

  Future<bool> saveBook() async {
    if ([
      title,
      description,
      author,
      imageUrl,
    ].any((value) => value.trim().isEmpty)) {
      _errorMessage = 'Preencha todos os campos.';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _booksRepository.insertBook(
        BookModel(
          title: title.trim(),
          description: description.trim(),
          author: author.trim(),
          imageUrl: imageUrl.trim(),
        ),
      );
      return true;
    } catch (_) {
      _errorMessage = 'Não foi possível salvar o livro.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
