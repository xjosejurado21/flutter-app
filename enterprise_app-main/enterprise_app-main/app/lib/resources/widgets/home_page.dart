import 'package:app/resources/classes/local.dart';
import 'package:app/resources/globals.dart';
import 'package:app/resources/widgets/categories.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/presentation/screens/home/categories.dart';
import 'package:app/resources/widgets/local_card.dart';
import 'package:app/resources/widgets/enterprise_profile_screen.dart';

class HomePageBuild extends StatelessWidget {
  const HomePageBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;
    final List<Category> categories = globalCategories;
    categories.removeWhere((category) => category.id == 'none');

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Theme.of(context).secondaryHeaderColor,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 5.0, left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Busca tiendas, locales, etc...',
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).primaryColor,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 10),
                              ),
                              onSubmitted: (value) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SearchResultsPage(searchText: value),
                                  ),
                                );
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.public),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      title: const Text('Ubicación actual'),
                      trailing: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                      onTap: () {},
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categorías',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const CategoriesPage(),
                                ),
                              );
                            },
                            child: const Text('Ver todas'),
                          ),
                        ],
                      ),
                    ),
                   SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: CategoryIconWidget(
                            category: categories[index],
                          ),
                        );
                      },
                    ),
                  ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0)
                          .copyWith(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Locales populares',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const SearchResultsPage(searchText: ''),
                                ),
                              );
                            },
                            child: const Text('Ver todos'),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: firestore.collection('companies').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Algo salió mal');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        var docs = snapshot.data!.docs;
                        return Column(
                          children: docs.map((doc) {
                            var data = doc.data() as Map<String, dynamic>;
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
                                        EnterprisePage(localId: doc.id),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultsPage extends StatefulWidget {
  final String searchText;

  const SearchResultsPage({super.key, required this.searchText});

  @override
  SearchResultsPageState createState() => SearchResultsPageState();
}

class SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _searchText = widget.searchText;
    _searchController.text = _searchText;
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Locales',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar locales...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.collection('companies').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Algo salió mal');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                var docs = snapshot.data!.docs;

                // Filtrar los documentos según el texto de búsqueda
                var filteredDocs = docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  var name = data['name'] as String;
                  return name.toLowerCase().contains(_searchText.toLowerCase());
                }).toList();

                return ListView(
                  children: filteredDocs.map((doc) {
                    var data = doc.data() as Map<String, dynamic>;
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
                            builder: (_) => EnterprisePage(localId: doc.id),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
