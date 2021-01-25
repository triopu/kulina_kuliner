import 'dart:convert';

class ProductData {
  final int id;
  final String name;
  final String imageUrl;
  final String brandName;
  final String packageName;
  final int price;
  final double rating;
  int amount;
  String date;

  ProductData(
      {this.id,
      this.name,
      this.imageUrl,
      this.brandName,
      this.packageName,
      this.price,
      this.rating,
      this.amount,
      this.date});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    DateTime today = new DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return ProductData(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      brandName: json['brand_name'],
      packageName: json['package_name'],
      price: json['price'],
      rating: json['rating'],
      amount: json['amount'] ?? 0,
      date: json['date'] ?? today.toString(),
    );
  }
  static Map<String, dynamic> toMap(ProductData productData) => {
        'id': productData.id,
        'name': productData.name,
        'image_url': productData.imageUrl,
        'brand_name': productData.brandName,
        'package_name': productData.packageName,
        'price': productData.price,
        'rating': productData.rating,
        'amount': productData.amount,
        'date': productData.date,
      };

  static String encode(List<ProductData> productData) => json.encode(
        productData
            .map<Map<String, dynamic>>((music) => ProductData.toMap(music))
            .toList(),
      );

  static List<ProductData> decode(String productData) =>
      (json.decode(productData) as List<dynamic>)
          .map<ProductData>((item) => ProductData.fromJson(item))
          .toList();
}
