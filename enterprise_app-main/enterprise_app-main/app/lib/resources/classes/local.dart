import 'package:flutter/material.dart';

enum CategoryType {
  none,
  coffeeBar,
}

class Local {
  final String imageUrl;
  final String name;
  final double rating;
  late String distance;
  late String categoryId;

  Local(
      {required this.imageUrl,
      required this.name,
      required this.rating,
      this.distance = "0",
      this.categoryId = 'none'});
}

class Category {
  final String name;
  final String id;
  final IconData icon;

  Category({
    required this.name,
    required this.id,
    required this.icon,
  });
}
