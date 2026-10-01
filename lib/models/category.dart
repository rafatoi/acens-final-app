class Category {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['strCategory'],
      imageUrl: map['strCategoryThumb'],
    );
  }
}