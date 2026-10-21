import 'package:sqflite/sqflite.dart';

import '../models/book_model.dart';
import 'books_repository.dart';

class LocalBooksRepository implements BooksRepository {
  static const _databaseName = 'books.db';
  static const _tableName = 'books';

  Database? _database;

  Future<Database> get _databaseInstance async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    _database = await openDatabase(
      '$databasePath/$_databaseName',
      version: 1,
      onCreate: (database, version) async {
        await _createBooksTable(database);
      },
    );

    return _database!;
  }

  @override
  Future<List<BookModel>> listBooks() async {
    final database = await _databaseInstance;
    final rows = await database.query(_tableName, orderBy: 'title ASC');

    return rows.map(_bookFromMap).toList();
  }

  @override
  Future<BookModel?> getBook(String id) async {
    final database = await _databaseInstance;
    final rows = await database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [_localIdFromString(id)],
      limit: 1,
    );

    if (rows.isEmpty) {
      return null;
    }

    return _bookFromMap(rows.first);
  }

  @override
  Future<String> insertBook(BookModel book) async {
    final database = await _databaseInstance;
    final values = <String, Object?>{
      'title': book.title,
      'description': book.description,
      'author': book.author,
      'image_url': book.imageUrl,
    };

    if (book.id != null) {
      values['id'] = _localIdFromString(book.id!);
    }

    final id = await database.insert(_tableName, values);
    return id.toString();
  }

  @override
  Future<void> deleteBook(String id) async {
    final database = await _databaseInstance;
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [_localIdFromString(id)],
    );
  }

  Future<void> _createBooksTable(Database database) async {
    await database.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        author TEXT NOT NULL,
        image_url TEXT NOT NULL
      )
    ''');
  }

  BookModel _bookFromMap(Map<String, Object?> map) {
    return BookModel(
      id: map['id']!.toString(),
      title: map['title']! as String,
      description: map['description']! as String,
      author: map['author']! as String,
      imageUrl: map['image_url']! as String,
    );
  }

  int _localIdFromString(String id) => int.parse(id);
}
