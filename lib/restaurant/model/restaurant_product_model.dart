import 'package:actual/common/const/data.dart';

class RestaurantProductModel {
  final String id;
  final String name;
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel({
    required this.id,
    required this.name,
    required this.imgUrl,
    required this.detail,
    required this.price,
  });

  factory RestaurantProductModel.fromJson(
      {required Map<String, dynamic> json}) {
    return RestaurantProductModel(
      id: json['id'],
      name: json['name'],
      imgUrl: 'http://$ip${json['imgUrl']}',
      detail: json['detail'],
      price: json['price'],
    );
  }
}
