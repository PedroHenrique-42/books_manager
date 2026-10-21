import '../models/book_model.dart';

abstract class BooksRepository {
  Future<List<BookModel>> listBooks();

  Future<BookModel?> getBook(String id);

  Future<String> insertBook(BookModel book);

  Future<void> deleteBook(String id);
}
