library globals;

import 'package:app/resources/classes/local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Category> globalCategories = [
  Category(name: "Sin Categoría", id: "none", icon: FontAwesomeIcons.tag),
  Category(name: "Informática", id: "computing", icon: FontAwesomeIcons.laptop),
  Category(name: "Peluquería", id: "barber", icon: FontAwesomeIcons.cut),
  Category(name: "Bar/Cafetería", id: "coffeeBar", icon: FontAwesomeIcons.coffee),
  Category(name: "Panadería", id: "bakery", icon: FontAwesomeIcons.breadSlice),
  Category(name: "Fontanería", id: "plumbing", icon: FontAwesomeIcons.wrench),
];

String getCategoryName(String categoryId) {
  for (var category in globalCategories) {
    if (category.id == categoryId) {
      return category.name;
    }
  }
  return "Sin Categoría";
}