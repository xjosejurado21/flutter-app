import 'package:app/resources/classes/local.dart';
import 'package:app/resources/widgets/enterprise_profile_screen.dart';
import 'package:app/resources/widgets/local_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String categoryName;
  final String count;
  final IconData iconData;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.count,
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
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  bottomLeft: Radius.circular(24.0),
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                ),
                boxShadow: const [
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
                  subtitle: Text(
                    count,
                    style: theme.textTheme.titleSmall?.copyWith(color: theme.hintColor),
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
                child: Icon(iconData, color: Theme.of(context).secondaryHeaderColor, size: 24.0), // Ajusta el tamaño del ícono a 24.0 para que sea consistente
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
                child: Icon(Icons.chevron_right, color: Theme.of(context).secondaryHeaderColor, size: 24.0), // Ajusta el tamaño del ícono a 24.0 para que sea consistente
              ),
            ),
          ],
        ),
        const SizedBox(height: 10), // Espacio después del contenedor
      ],
    );
  }
}

class CategoryIconWidget extends StatelessWidget {
  final Category category;

  const CategoryIconWidget({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(category: category),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).secondaryHeaderColor,
            child: Icon(category.icon, size: 24.0), // Asegúrate de que todos los iconos tengan el mismo tamaño
          ),
          const SizedBox(height: 5),
          Text(category.name, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}


class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(category.name, style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white)),
      ),
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('companies')
              .where('category', isEqualTo: category.id)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
        
            // Construcción de la lista de locales
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                return LocalCard(
                                local: Local(
                                  imageUrl: data['portraitImage'] ??
                                      "assets/examples/company_profile.jpeg",
                                  name: data['name'] ?? "Desonocido",
                                  categoryId: data['category'] ?? 'none',
                                  rating: double.parse(data['rating'].toString()),
                                  distance: data['distance'] ?? "",
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          EnterprisePage(localId: document.id),
                                    ),
                                  );
                                },
                              );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

