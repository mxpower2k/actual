import 'package:actual/common/const/colors.dart';
import 'package:flutter/material.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;
  final String content;
  final List<Image>? images;

  const RatingCard({
    required this.avatarImage,
    required this.rating,
    required this.email,
    required this.content,
    this.images,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          avatarImage: avatarImage,
          email: email,
          rating: rating,
        ),
        _Body(),
        _Images(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final String email;
  final int rating;

  const _Header({
    required this.avatarImage,
    required this.email,
    required this.rating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: avatarImage,
          radius: 12.0,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _Images extends StatelessWidget {
  const _Images({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
