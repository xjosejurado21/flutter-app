import 'package:flutter/material.dart';

class LocalPopular {
  final String imageName;
  final String name;
  final String category;
  final double rating;
  final String distance;

  LocalPopular({
    required this.imageName,
    required this.name,
    required this.category,
    required this.rating,
    required this.distance,
  });
}

class LocalPopularCard extends StatelessWidget {
  final LocalPopular local;

  const LocalPopularCard({super.key, required this.local});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen del local
          Image.asset(
            local.imageName,
            width: double.infinity,
            height:
                180, // Ajusta la altura para mantener una relación de aspecto de 16:9
            fit: BoxFit.cover,
          ),

          // Nombre del local
          Container(
            padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
            child: Text(
              local.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),

          // Calificación y detalles del local
          Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: Row(
              children: [
                // Estrella y rating
                const Icon(Icons.star, color: Colors.amber, size: 20),
                Text(
                  '${local.rating} ',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.amber,
                  ),
                ),

                // Categoría
                Text(
                  local.category,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),

                const Text(
                  ' • ',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),

                // Distancia
                Text(
                  local.distance,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
