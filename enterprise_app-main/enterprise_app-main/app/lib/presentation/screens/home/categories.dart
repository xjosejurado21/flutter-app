import 'package:app/resources/classes/local.dart';
import 'package:app/resources/globals.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final IconData iconData;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: 10), // Espacio entre contenedores
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Container principal de la categoría
            Container(
              height: 80, // Altura incrementada del contenedor
              margin: const EdgeInsets.fromLTRB(40.0, 4.0, 40.0, 4.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 50.0, top: 5.0),
                child: ListTile(
                  title: Text(
                    categoryName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), // Aplica negrita al título
                  ),
                  onTap: () {
                    // Acción al tocar la categoría
                  },
                ),
              ),
            ),
            // Ícono de la categoría
            Positioned(
              left: 16.0,
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 32.0,
                child: Icon(iconData, color: Theme.of(context).secondaryHeaderColor, size: 30.0),
              ),
            ),
            // Flecha a la derecha con fondo circular negro
            Positioned(
              right: 25,
              top: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 15.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.chevron_right, color: Theme.of(context).secondaryHeaderColor, size: 30.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Espacio después del contenedor
      ],
    );
  }
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  CategoriesPageState createState() => CategoriesPageState();
}

class CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = globalCategories;

  String searchText = '';

  @override
  Widget build(BuildContext context) {

    List<Category> filteredCategories = categories.where((category) {
      return category.name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Categorías", style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white),),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Buscar categoría',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCategories.length,
              itemBuilder: (context, index) {
                final category = filteredCategories[index];
                return CategoryTile(
                  categoryName: category.name,
                  iconData: category.icon,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
