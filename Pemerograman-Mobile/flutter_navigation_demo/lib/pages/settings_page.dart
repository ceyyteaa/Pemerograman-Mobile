import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF0F5), Colors.white],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildSettingSection('Umum', [
                _buildSettingItem(
                    Icons.notifications_rounded, 'Notifikasi', true),
                _buildSettingItem(Icons.dark_mode_rounded, 'Mode Gelap', false),
                _buildSettingItem(Icons.language_rounded, 'Bahasa', null,
                    value: 'Indonesia'),
              ]),
              const SizedBox(height: 24),
              _buildSettingSection('Privasi', [
                _buildSettingItem(
                    Icons.security_rounded, 'Privasi & Keamanan', null),
                _buildSettingItem(Icons.lock_rounded, 'Kata Sandi', null),
              ]),
              const SizedBox(height: 24),
              _buildSettingSection('Lainnya', [
                _buildSettingItem(Icons.help_rounded, 'Bantuan', null),
                _buildSettingItem(Icons.info_rounded, 'Tentang', null),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666)),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title, bool? isSwitch,
      {String? value}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFEC407A).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFFEC407A), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: isSwitch != null
          ? Switch(
              value: isSwitch,
              onChanged: (val) {},
              activeColor: const Color(0xFFEC407A),
            )
          : Text(value ?? '', style: const TextStyle(color: Colors.grey)),
      onTap: () {},
    );
  }
}
