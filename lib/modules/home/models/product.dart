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

  ProductData(
      {this.id,
      this.name,
      this.imageUrl,
      this.brandName,
      this.packageName,
      this.price,
      this.rating,
      this.amount});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      brandName: json['brand_name'],
      packageName: json['package_name'],
      price: json['price'],
      rating: json['rating'],
      amount: json['amount'] ?? 0,
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
