import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddCompanyPage extends StatefulWidget {
  const AddCompanyPage({super.key});

  @override
  AddCompanyPageState createState() => AddCompanyPageState();
}

class AddCompanyPageState extends State<AddCompanyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userDniController = TextEditingController();
  final TextEditingController _companyDniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedCategory = 'Panadería';
  final ImagePicker _picker = ImagePicker();
  File? _localImage;
  File? _coverImage;

  final List<String> _categories = [
    'Panadería',
    'Cafetería',
    'Peluquería',
    'Restaurante',
    'Librería',
    'Gimnasio',
    'Farmacia',
    'Supermercado',
  ];

  Future<void> _pickLocalImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _localImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String localImageUrl = '';
      String coverImageUrl = '';

      if (_localImage != null) {
        String localFileName = '${DateTime.now().millisecondsSinceEpoch}_local.png';
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('company_images').child(localFileName).putFile(_localImage!);
        TaskSnapshot snapshot = await uploadTask;
        localImageUrl = await snapshot.ref.getDownloadURL();
      }

      if (_coverImage != null) {
        String coverFileName = '${DateTime.now().millisecondsSinceEpoch}_cover.png';
        UploadTask uploadTask = FirebaseStorage.instance.ref().child('company_images').child(coverFileName).putFile(_coverImage!);
        TaskSnapshot snapshot = await uploadTask;
        coverImageUrl = await snapshot.ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('pending_companies').add({
        'name': _nameController.text,
        'category': _selectedCategory,
        'userDni': _userDniController.text,
        'companyDni': _companyDniController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'localImageUrl': localImageUrl,
        'coverImageUrl': coverImageUrl,
        'submittedAt': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud de empresa enviada')),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Widget _buildImagePicker({
    required String label,
    required File? imageFile,
    required VoidCallback onPickImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: imageFile == null
                ? Center(
                    child: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey[800],
                      size: 50,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        items: _categories.map((category) {
          return DropdownMenuItem<String>(
            value: category,
            child: Text(category),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Añadir Empresa',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre de la Empresa',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el nombre de la empresa';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildCategoryDropdown(),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _userDniController,
                          decoration: const InputDecoration(
                            labelText: 'DNI del Usuario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el DNI del usuario';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _companyDniController,
                          decoration: const InputDecoration(
                            labelText: 'DNI de la Empresa',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el DNI de la empresa';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Número de Teléfono',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa el número de teléfono';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa la dirección';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildImagePicker(
                          label: 'Foto del Local',
                          imageFile: _localImage,
                          onPickImage: _pickLocalImage,
                        ),
                        _buildImagePicker(
                          label: 'Foto de Portada del Local',
                          imageFile: _coverImage,
                          onPickImage: _pickCoverImage,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, // Fondo negro
                            foregroundColor: Colors.white, // Texto blanco
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30), // Bordes redondeados
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: _submitForm,
                          child: const Text('Enviar Solicitud'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
