import 'package:flutter/material.dart';

class SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool showNotification;
  final int notificationCount;
  final int textColor;
  final int iconColor;

  const SettingsListItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.showNotification = false,
    this.notificationCount = 0,
    this.textColor = 0,
    this.iconColor = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor, // Un color claro de ejemplo
        borderRadius: BorderRadius.circular(10), // Bordes ligeramente redondeados
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).hintColor, // Un color de fondo para el ícono
          child: Icon(icon, color: Color(iconColor)),
        ),
title: Text(text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(textColor))),
        trailing: showNotification ? _buildNotificationIcon(notificationCount) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildNotificationIcon(int count) {
    // Solo muestra el número si hay notificaciones
    return count > 0 ? Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(
        minWidth: 20,
        minHeight: 20,
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    ) : const SizedBox.shrink();  // Devuelve un widget vacío si no hay notificaciones
  }
}