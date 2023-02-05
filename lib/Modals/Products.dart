class Product {
  final String? title;
  final String? category;
  final int price;
  final String? image;

  Product({
    required this.title,
    required this.category,
    required this.price,
    required this.image,
  });

  factory Product.fromAPI({required Map data}) {
    return Product(
      title: data["title"],
      category: data["category"],
      price: data["price"],
      image: data["thumbnail"],
    );
  }
}
