class BookModel {
  final int? id;
  final String title;
  final String description;
  final String author;
  final String imageUrl;

  BookModel({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.imageUrl,
  });
}
