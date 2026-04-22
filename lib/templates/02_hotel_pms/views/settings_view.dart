import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final bool isDarkMode;
  final bool pushNotifications;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<bool> onPushChanged;

  const SettingsView({
    super.key,
    required this.isDarkMode,
    required this.pushNotifications,
    required this.onThemeChanged,
    required this.onPushChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Preferences', style: TextStyle(fontWeight: FontWeight.w700, color: subtitleColor)),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
          value: pushNotifications,
          onChanged: onPushChanged,
          activeColor: const Color(0xFF3B82F6),
        ),
        SwitchListTile(
          title: Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
          value: isDarkMode,
          onChanged: onThemeChanged,
          activeColor: const Color(0xFF3B82F6),
        ),
        Divider(height: 32, color: isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        Text('Account', style: TextStyle(fontWeight: FontWeight.w700, color: subtitleColor)),
        const SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.person_outline, color: subtitleColor),
          title: Text('Profile details', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
          trailing: Icon(Icons.chevron_right, color: subtitleColor),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.security, color: subtitleColor),
          title: Text('Security & Password', style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
          trailing: Icon(Icons.chevron_right, color: subtitleColor),
          onTap: () {},
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
          child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ),
      ],
    );
  }
}