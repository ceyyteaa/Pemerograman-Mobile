import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodata Diri',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Poppins',
      ),
      home: const ProfilePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Image
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.pink[300]!,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink[100]!,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.pink[100],
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.pink,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Name
              Text(
                'Cerry Noviyanti',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[800],
                  letterSpacing: 1.2,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Profession
              Text(
                '701230042',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.pink[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Bio Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink[100]!,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Personal Info Row
                    _buildInfoRow(
                      icon: Icons.cake,
                      title: 'Umur',
                      value: '20 Tahun',
                    ),
                    const SizedBox(height: 15),
                    
                    _buildInfoRow(
                      icon: Icons.school,
                      title: 'Pendidikan',
                      value: 'S1 Sistem Informasi',
                    ),
                    const SizedBox(height: 15),
                    
                    _buildInfoRow(
                      icon: Icons.location_on,
                      title: 'Kota',
                      value: 'Jambi',
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // About Me Section
                    Text(
                      'Halo! Saya seorang Mahasiswi UIN Jambi dan saya suka belajar hal baru serta berkolaborasi dalam proyek kreatif.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSocialButton(
                    icon: Icons.email,
                    color: Colors.pink,
                    onPressed: () {
                      // Aksi email
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.phone,
                    color: Colors.purple,
                    onPressed: () {
                      // Aksi telepon
                    },
                  ),
                  _buildSocialButton(
                    icon: Icons.share,
                    color: Colors.deepPurple,
                    onPressed: () {
                      // Aksi share
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Contact Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Aksi kontak
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  icon: const Icon(Icons.chat),
                  label: const Text(
                    'Hubungi Saya',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.pink,
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.pink[800],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}