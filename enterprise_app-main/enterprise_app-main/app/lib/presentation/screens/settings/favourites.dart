import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteItem {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;

  FavoriteItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
  });
}

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  late User? _user;
  late List<FavoriteItem>? favoriteItems; // Cambiado a tipo nullable

  @override
  void initState() {
    super.initState();
    // No inicialices favoriteItems aquí
    // Obtener el usuario actualmente autenticado
    _user = FirebaseAuth.instance.currentUser;
    // Cargar los elementos de favoritos
    loadFavoriteItems();
  }

  Future<void> loadFavoriteItems() async {
    final DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();

    final List<String> favoriteIds =
        List<String>.from(userSnapshot['favorites']);

    final List<FavoriteItem> items = [];

    for (final id in favoriteIds) {
      final DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('companies')
          .doc(id)
          .get();
      final data = doc.data();
      if (data != null) {
        items.add(
          FavoriteItem(
            id: doc.id,
            name: data['name'],
            imageUrl: data['logoUrl'] ?? "https://cdn-icons-png.flaticon.com/512/1077/1077114.png",
            rating: data['rating'].toDouble(),
          ),
        );
      }
    }

    setState(() {
      favoriteItems = items;
    });
  }

  Future<void> removeFromFavorites(String itemId) async {
    // Eliminar el elemento de favoritos del usuario en Firebase
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .update({
      'favorites': FieldValue.arrayRemove([itemId]),
    });
    // Recargar los elementos de favoritos después de eliminar uno
    loadFavoriteItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
      ),
      body: favoriteItems != null
          ? ListView.builder(
              itemCount: favoriteItems!.length, // Acceder a favoriteItems con el operador de navegación seguro
              itemBuilder: (context, index) {
                final item = favoriteItems![index]; // Acceder a favoriteItems con el operador de navegación seguro
                return ListTile(
                  leading: Image.network(
                    item.imageUrl,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name),
                  subtitle: Text('Valoración: ${item.rating}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.heart_broken, size: 40, color: Color.fromARGB(255, 186, 49, 39),),
                    onPressed: () {
                      // Llamar a la función para eliminar de favoritos al presionar el botón
                      removeFromFavorites(item.id);
                    },
                  ),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
