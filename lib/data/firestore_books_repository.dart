import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book_model.dart';
import 'books_repository.dart';

class FirestoreBooksRepository implements BooksRepository {
  FirestoreBooksRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  static const _collectionName = 'books';

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _firestore.collection(_collectionName);

  @override
  Future<List<BookModel>> listBooks() async {
    final snapshot = await _booksCollection.orderBy('title').get();
    return snapshot.docs.map(_bookFromDocument).toList();
  }

  @override
  Future<BookModel?> getBook(String id) async {
    final document = await _booksCollection.doc(id).get();
    final data = document.data();

    if (!document.exists || data == null) {
      return null;
    }

    return _bookFromData(document.id, data);
  }

  @override
  Future<String> insertBook(BookModel book) async {
    final data = <String, Object?>{
      'title': book.title,
      'description': book.description,
      'author': book.author,
      'imageUrl': book.imageUrl,
    };

    if (book.id case final id?) {
      await _booksCollection.doc(id).set(data);
      return id;
    }

    final document = await _booksCollection.add(data);
    return document.id;
  }

  @override
  Future<void> deleteBook(String id) async {
    await _booksCollection.doc(id).delete();
  }

  BookModel _bookFromDocument(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
  ) {
    return _bookFromData(document.id, document.data());
  }

  BookModel _bookFromData(String id, Map<String, dynamic> data) {
    return BookModel(
      id: id,
      title: data['title'] as String,
      description: data['description'] as String,
      author: data['author'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }
}
