import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/presentation/screens/home/navigation_state.dart';
import 'package:app/presentation/screens/settings/settings.dart';
import 'package:app/resources/widgets/home_page.dart';
import 'package:app/presentation/screens/profiles/my_profile_page.dart';

class Menu extends StatefulWidget {
  final int currentIndex;
  final Function(int) onItemSelected;

  const Menu({super.key, required this.currentIndex, required this.onItemSelected});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Menu> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationState = Provider.of<NavigationState>(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              navigationState.setSelectedIndex(index);
              widget.onItemSelected(index);  // Llama a la función pasada en el constructor
            },
            children: const [
              HomePageBuild(),
              MyProfilePage(),
              SettingsPage(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomNavigationBar(navigationState),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(NavigationState navigationState) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: BottomNavigationBar(
      currentIndex: navigationState.selectedIndex, // Asegúrate de que esto se sincroniza con el índice de la página mostrada.
      onTap: (index) {
          navigationState.setSelectedIndex(index);
          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeInOut);
          widget.onItemSelected(index);  // Asegúrate de que esto refleje el cambio.
      },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Otros'),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).secondaryHeaderColor,
        unselectedItemColor: Theme.of(context).hintColor,
        elevation: 0,
      ),
    );
  }
}
