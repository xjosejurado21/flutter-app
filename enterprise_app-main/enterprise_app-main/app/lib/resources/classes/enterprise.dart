class Enterprise {
  final String id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;

  Enterprise({this.id = '', required this.nombre, required this.direccion, required this.telefono, required this.email});

  factory Enterprise.fromMap(Map<String, dynamic> data, String id) {
    return Enterprise(
      id: id,
      nombre: data['nombre'],
      direccion: data['direccion'],
      telefono: data['telefono'],
      email: data['email'],
    );
  }
}


