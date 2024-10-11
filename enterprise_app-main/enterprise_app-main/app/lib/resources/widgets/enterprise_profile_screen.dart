import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/resources/widgets/profile_header.dart';
import 'package:app/resources/widgets/review_card.dart';

class EnterprisePage extends StatefulWidget {
  final String localId;

  const EnterprisePage({super.key, required this.localId});

  @override
  EnterprisePageState createState() => EnterprisePageState();
}

class EnterprisePageState extends State<EnterprisePage> {
  List<String> reviews = [];
  bool showAllReviews = false;
  Map<String, dynamic>? localData;
  List<String> imgList = []; // Lista para almacenar todas las URLs de imágenes.

  @override
  void initState() {
    super.initState();
    fetchLocalData();
    fetchReviews();
  }

  Future<void> fetchLocalData() async {
    var doc = await FirebaseFirestore.instance.collection('companies').doc(widget.localId).get();
    if (doc.exists) {
      setState(() {
        localData = doc.data();
      });
      loadImages();
    }
  }

  Future<void> fetchReviews() async {
    var collection = FirebaseFirestore.instance.collection('reviews').where('localId', isEqualTo: widget.localId);
    var querySnapshot = await collection.get();
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      reviews.add(data['text'] ?? '');
    }
    setState(() {});
  }

  Future<void> loadImages() async {
    // Load the portrait image if it exists
    if (localData!.containsKey('portraitImage') && localData!['portraitImage'] != null) {
      imgList.add(await getImageUrl(localData!['portraitImage']));
    } else {
      imgList.add(await getImageUrl('assets/examples/company_profile.jpeg'));
    }

    // Load any other images specified in the array
    if (localData!.containsKey('otherImages') && localData!['otherImages'] != null) {
      List<dynamic> otherImages = localData!['otherImages'];
      for (String imageName in otherImages) {
        imgList.add(await getImageUrl(imageName));
      }
    }

    setState(() {});
  }

  Future<String> getImageUrl(String imageName) async {
    return await firebase_storage.FirebaseStorage.instance.ref(imageName).getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(localData?['name'] ?? 'Cargando...', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: Colors.white)),
      ),
      body: localData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: screenSize.height / 3,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          viewportFraction: 1.0,
                          aspectRatio: 2.0,
                        ),
                        items: imgList.map((item) => Image.network(item, fit: BoxFit.fitWidth, width: 1000)).toList(),
                      ),
                      Positioned(
                      top: screenSize.height / 3 - 20,
                      left: 0,
                      right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              ProfileHeader(localId: widget.localId),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Reseñas',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: Image.asset('assets/profiles/resenia.png'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Column(
                                children: showAllReviews
                                    ? reviews.map((review) => ReviewCard(review: review)).toList()
                                    : reviews.take(3).map((review) => ReviewCard(review: review)).toList(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        showAllReviews = !showAllReviews;
                                      });
                                    },
                                    child: Text(
                                      showAllReviews ? 'Ver menos' : 'Ver todos',
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Ubicación',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              // Opción para agregar un widget de mapa u otra representación de la ubicación
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail, color: Colors.white),
            label: '',
          ),
          BottomNavigationBarItem( 
            icon: Icon(Icons.location_on, color: Colors.white),
            label: '',
          ),
        ],
      ),
    );
  }
}
