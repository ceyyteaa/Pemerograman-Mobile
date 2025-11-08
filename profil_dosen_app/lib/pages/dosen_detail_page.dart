import 'package:flutter/material.dart';
import '../models/dosen_model.dart';

class DosenDetailPage extends StatelessWidget {
  final Dosen dosen;

  const DosenDetailPage({Key? key, required this.dosen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header dengan background gradient - DIUBAH
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10, // DIKURANGI
              bottom: 30,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [dosen.color, dosen.color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // DITAMBAH
              children: [
                // Back Button - POSISI DIUBAH
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child:
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Profile Info - DIUBAH POSISI
                SizedBox(height: 10), // DITAMBAH
                _buildProfileHeader(),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // Informasi Kontak
                  _buildContactSection(),
                  SizedBox(height: 20),

                  // Mata Kuliah
                  _buildCoursesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // METHOD BARU UNTUK HEADER YANG LEBIH PRESISI
  Widget _buildProfileHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar Container - DIUBAH
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/dosen${dosen.id}.png', // Ganti dengan path foto
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.person,
                  color: dosen.color,
                  size: 50,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(
          dosen.nama,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          dosen.jabatan,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_mail, color: dosen.color),
                SizedBox(width: 10),
                Text(
                  'Informasi Kontak',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildContactItem(Icons.email, 'Email', dosen.email),
            _buildContactItem(Icons.phone, 'Telepon', dosen.phone),
            _buildContactItem(Icons.location_on, 'Kantor', dosen.office),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40, // DITAMBAH UNTUK KONSISTENSI
            child: Icon(icon, color: dosen.color, size: 22),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book, color: dosen.color),
                SizedBox(width: 10),
                Text(
                  'Mata Kuliah yang Diampu',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: dosen.mataKuliah
                  .map((mk) => Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              dosen.color.withOpacity(0.8),
                              dosen.color,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: dosen.color.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          mk,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}