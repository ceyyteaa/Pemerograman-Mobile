import 'package:flutter/material.dart';
import 'package:flutter_navigation_demo/pages/profile_page.dart';
import 'package:flutter_navigation_demo/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HalamanUtama(),
    const ProfilePage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFFEC407A),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: 'Pengaturan',
        ),
      ],
    );
  }
}

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF0F5), Colors.white],
        ),
      ),
      child: SafeArea(
        // Tambahkan SafeArea
        child: SingleChildScrollView(
          // Tambahkan ScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildMenuGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEC407A).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.spa_rounded,
            size: 40,
            color: Color(0xFFEC407A),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Selamat Datang!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Apa yang ingin Anda lakukan hari ini?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true, // Penting untuk GridView dalam ScrollView
      physics:
          const NeverScrollableScrollPhysics(), // Nonaktifkan scroll internal
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMenuCard(
          Icons.person_rounded,
          'Profil Saya',
          const Color(0xFFEC407A),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ProfilePage())),
        ),
        _buildMenuCard(
          Icons.settings_rounded,
          'Pengaturan',
          const Color(0xFFAB47BC),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const SettingsPage())),
        ),
        _buildMenuCard(
          Icons.send_rounded,
          'Kirim Data',
          const Color(0xFF42A5F5),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => HalamanKirimData())),
        ),
        _buildMenuCard(
          Icons.favorite_rounded,
          'Favorit',
          const Color(0xFFEF5350),
          () => _showToast(context, 'Fitur favorit akan datang!'),
        ),
      ],
    );
  }

  Widget _buildMenuCard(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEC407A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class HalamanKirimData extends StatefulWidget {
  const HalamanKirimData({super.key});

  @override
  State<HalamanKirimData> createState() => _HalamanKirimDataState();
}

class _HalamanKirimDataState extends State<HalamanKirimData> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Kirim Data'),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                Expanded(
                  // Gunakan Expanded untuk form
                  child: _buildForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEC407A).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.send_rounded,
            size: 40,
            color: Color(0xFFEC407A),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Kirim Informasi',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Isi data diri Anda di bawah ini',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      // Tambahkan scroll untuk form
      child: Column(
        children: [
          TextField(
            controller: _namaController,
            decoration: InputDecoration(
              labelText: 'Nama Lengkap',
              prefixIcon:
                  const Icon(Icons.person_rounded, color: Color(0xFFEC407A)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Alamat Email',
              prefixIcon:
                  const Icon(Icons.email_rounded, color: Color(0xFFEC407A)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _kirimData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEC407A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kirim Data', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                const Text('Batal', style: TextStyle(color: Color(0xFFEC407A))),
          ),
        ],
      ),
    );
  }

  void _kirimData() {
    if (_namaController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanDataDiterima(
            nama: _namaController.text,
            email: _emailController.text,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap isi semua field!'),
          backgroundColor: Color(0xFFEC407A),
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

class HalamanDataDiterima extends StatelessWidget {
  final String nama;
  final String email;

  const HalamanDataDiterima(
      {super.key, required this.nama, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Data Diterima'),
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: Colors.green, size: 50),
                ),
                const SizedBox(height: 24),
                const Text('Berhasil!',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                const Text('Data Anda telah berhasil dikirim',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                _buildDataCard(),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEC407A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child:
                        const Text('Kembali', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEC407A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.person_rounded, color: Color(0xFFEC407A)),
              ),
              title: const Text('Nama',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(nama, style: const TextStyle(fontSize: 16)),
            ),
            const Divider(height: 1),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF42A5F5).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.email_rounded, color: Color(0xFF42A5F5)),
              ),
              title: const Text('Email',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(email, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
