import 'package:app/presentation/screens/settings/about_us.dart';
import 'package:app/presentation/screens/settings/favourites.dart';
import 'package:app/resources/functions/login_register.dart';
import 'package:app/resources/functions/navigation.dart';
import 'package:app/resources/widgets/settings.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de elementos de ajustes representados por mapas.
    final List<Map<String, dynamic>> settingsItems = [
      {
        'icon': Icons.monetization_on,
        'text': 'Valoraciones',
        'onTap': () {/* futura función */},
      },
      {
        'icon': Icons.favorite,
        'text': 'Mis Lugares Fav',
        'onTap': () {navigateTo(context, const FavoritesPage());},
      },
      {
        'icon': Icons.notifications,
        'text': 'Notificaciones',
        'onTap': () {/* futura función */},
        'showNotification': true,
        'notificationCount': 10,
      },
      {
        'icon': Icons.info_outline,
        'text': 'Sobre Nosotros',
        'onTap': () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AboutUsPage())),
      },
      {
        'icon': Icons.logout,
        'text': 'Cerrar sesión',
        'onTap': () => {
          logout(context)
        },
        'textColor': 0xFFFF0000,
        'iconColor': 0xFF990000,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: settingsItems.length,
          itemBuilder: (context, index) {
            final item = settingsItems[index];
            return SettingsListItem(
              icon: item['icon'],
              text: item['text'],
              onTap: item['onTap'],
              showNotification: item['showNotification'] ?? false,
              notificationCount: item['notificationCount'] ?? 0,
              textColor: item['textColor'] ?? 0xFFFFFFFF,
              iconColor: item['iconColor'] ?? 0xFFFFFFFF,
            );
          },
        ),
      ),
    );
  }
}
