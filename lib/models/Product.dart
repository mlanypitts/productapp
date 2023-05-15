
import 'dart:typed_data';

class Product {
  final String title;
  final String description;
  final double price;
  final Uint8List? photo;

  const Product({
    required this.title,
    required this.description,
    required this.price,
    this.photo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        title: json['title'],
        description: json['desc'],
        price: json['price']
    );
  }
}
