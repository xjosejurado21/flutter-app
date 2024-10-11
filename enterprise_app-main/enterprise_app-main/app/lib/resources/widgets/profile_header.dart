import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String localId;

  const ProfileHeader({super.key, required this.localId});

  @override
  ProfileHeaderState createState() => ProfileHeaderState();
}

class ProfileHeaderState extends State<ProfileHeader> {
  Map<String, dynamic>? localData;  // Haz localData nullable

  @override
  void initState() {
    super.initState();
    fetchLocalData();
  }

  void fetchLocalData() async {
    var doc = await FirebaseFirestore.instance.collection('companies').doc(widget.localId).get();
    if (doc.exists) {
      setState(() {
        localData = doc.data() as Map<String, dynamic>;  // Siempre asegúrate de que el dato obtenido de Firestore no sea null antes de usarlo
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Muestra un indicador de carga mientras localData es null
    if (localData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localData!['name'] ?? 'Nombre Desconocido',  // Usa el operador ! dado que ya aseguramos que localData no es null arriba
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 4),
            Text(
              localData!['rating']?.toString() ?? 'N/A',
              style: const TextStyle(fontSize: 16, color: Colors.yellow),
            ),
            const SizedBox(width: 4),
            Text(
              localData!['category'] ?? 'Sin categoría',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Text(
              '·',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 4),
            Text(
              localData!['direction'] ?? 'Sin ubicación',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          'Descripción',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          localData!['description'] ?? 'Descripción no disponible',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
