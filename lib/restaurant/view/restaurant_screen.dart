import 'package:actual/common/const/data.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  Future<List> pageinateRestaurant() async {
    final dio = new Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    final resp = await dio.get(
      'http://$ip/restaurant',
      options: Options(
        headers: {'authorization': 'Bearer $accessToken'},
      ),
    );

    return resp.data['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List>(
          future: pageinateRestaurant(),
          builder: (context, AsyncSnapshot<List> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            print(snapshot.data);

            return ListView.separated(
              itemBuilder: (_, index) {
                final item = snapshot.data![index];
                final pItem = RestaurantModel(
                  id: item['id'],
                  name: item['name'],
                  thumbUrl: 'http://$ip${item['thumbUrl']}',
                  tags: List<String>.from(item['tags']),
                  priceRange: RestaurantPriceRange.values
                      .firstWhere((e) => e.name == item['priceRange']),
                  ratings: item['ratings'],
                  ratingsCount: item['ratingsCount'],
                  deliveryTime: item['deliveryTime'],
                  deliveryFee: item['deliveryFee'],
                );

                return RestaurantCard(
                  image: Image.network(
                    pItem.thumbUrl,
                    fit: BoxFit.cover,
                  ),
                  name: pItem.name,
                  tags: pItem.tags,
                  ratingsCount: pItem.ratingsCount,
                  ratings: pItem.ratings,
                  deliveryTime: pItem.deliveryTime,
                  deliveryFee: pItem.deliveryFee,
                );
              },
              separatorBuilder: (_, index) {
                return const SizedBox(
                  height: 16.0,
                );
              },
              itemCount: snapshot.data!.length,
            );
          },
        ),
      ),
    );
  }
}
