import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:app/resources/widgets/enterprise_profile_screen.dart'; // Importa EnterprisePage

import 'add_company_page.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  MyProfilePageState createState() => MyProfilePageState();
}

class MyProfilePageState extends State<MyProfilePage> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  String _photoUrl = 'assets/profiles/userProfile.png';
  User? _currentUser;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _companies = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _getUserData() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).get();
      var data = userDoc.data() as Map<String, dynamic>;
      var photoUrl = 'assets/profiles/userProfile.png';
      if (data.containsKey('photoUrl')) {
        photoUrl = data['photoUrl'].toString().isEmpty ? 'assets/profiles/userProfile.png' : data['photoUrl'];
      }
      if (mounted) {
        setState(() {
          _nameController.text = data['name'];
          _photoUrl = photoUrl;
        });
      }
      _getCompanies(data['companies']);
    }
  }

  Future<void> _getCompanies(List<dynamic> companyIds) async {
    List<Map<String, dynamic>> companyData = [];
    for (String companyId in companyIds) {
      DocumentSnapshot companyDoc = await FirebaseFirestore.instance.collection('companies').doc(companyId).get();
      if (companyDoc.exists) {
        companyData.add({
          'id': companyId,
          'name': companyDoc['name'],
          'rating': companyDoc['rating'],
        });
      }
    }
    if (mounted) {
      setState(() {
        _companies = companyData;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).update({
        'name': _nameController.text,
        'photoUrl': _photoUrl,
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${_currentUser!.uid}_profile.png';
      UploadTask uploadTask = FirebaseStorage.instance.ref().child('profile_pictures').child(fileName).putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      if (mounted) {
        setState(() {
          _photoUrl = downloadUrl;
        });
      }
      _updateUserData();
    }
  }

  void _navigateToCompanyDetail(String companyId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EnterprisePage(localId: companyId)), // Navegar a EnterprisePage
    );
  }

  void _navigateToAddCompany() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddCompanyPage()),
    );
  }

  Widget _buildCompanyCard(Map<String, dynamic> company) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        title: Text(company['name']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < company['rating'] ? Icons.star : Icons.star_border,
              color: Colors.amber,
            );
          }),
        ),
        onTap: () => _navigateToCompanyDetail(company['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).secondaryHeaderColor,
        child: Stack(
          children: [
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(_isEditing ? Icons.check : Icons.edit),
                iconSize: 32,
                onPressed: () {
                  setState(() {
                    if (_isEditing && _nameController.text.trim().isNotEmpty) {
                      _isEditing = false;
                      _updateUserData();
                    } else if (!_isEditing) {
                      _isEditing = true;
                    }
                  });
                },
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 100),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Theme.of(context).primaryColor,
                      backgroundImage: _photoUrl.startsWith('assets')
                          ? AssetImage(_photoUrl)
                          : (_photoUrl.isNotEmpty
                              ? NetworkImage(_photoUrl)
                              : const AssetImage('assets/profiles/fotoPerfil.png')) as ImageProvider,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _isEditing
                      ? SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _nameController,
                            textAlign: TextAlign.center,
                            maxLength: 20,
                            decoration: const InputDecoration(
                              labelText: 'Nombre',
                              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                            ),
                          ),
                        )
                      : Text(
                          _nameController.text,
                          style: const TextStyle(fontSize: 20),
                        ),
                  const SizedBox(height: 60),
                  const Text(
                    'Empresas Asociadas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                 const SizedBox(height: 10),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Fondo negro
                    foregroundColor: Colors.white, // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Bordes redondeados
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: _navigateToAddCompany,
                  child: const Text('Añadir Empresa'),
                ),
                  _companies.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: _companies.length,
                            itemBuilder: (context, index) {
                              return _buildCompanyCard(_companies[index]);
                            },
                          ),
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
