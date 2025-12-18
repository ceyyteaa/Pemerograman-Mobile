import 'package:flutter/material.dart';

class Dosen {
  final String id;
  final String nama;
  final String jabatan;
  final String email;
  final String phone;
  final String office;
  final List<String> mataKuliah;
  final Color color;
  final String foto;

  Dosen({
    required this.id,
    required this.nama,
    required this.jabatan,
    required this.email,
    required this.phone,
    required this.office,
    required this.mataKuliah,
    required this.color,
    required this.foto,
  });
}

// Update data dummy dengan foto
List<Dosen> dummyDosen = [
  Dosen(
    id: '1',
    nama: 'AHMAD NASUKHA, S.Hum., M.S.I',
    jabatan: '1988072220171009',
    email: 'AhmadNasukha@uin.jambi.ac.id',
    phone: '+62 812-3456-7890',
    office: 'Ruang Dosen SI Lt. 6',
    mataKuliah: [
      'Kecerdasan Buatan',
      'Pemrograman Mobile',
      'Analisis & Perancangan Sistem Informasi',
      'Basis Data'
    ],
    color: Color.fromARGB(255, 145, 13, 13),
    foto: 'assets/images/dosen1.png',
  ),
  Dosen(
    id: '2',
    nama: 'DILA NURLAILA, M.Kom',
    jabatan: '1571015201960020',
    email: 'DilaNurlaila@uin.jambi.ac.id',
    phone: '+62 813-9876-5432',
    office: 'Ruang Dosen SI Lt. 6',
    mataKuliah: [
      'Teknik Jaringan Komputer',
      'Basis Data',
      'Rekayasa Perangkat Lunak',
      'Manajemen Proyek Sistem Informasi'
    ],
    color: Color.fromARGB(255, 159, 25, 164),
    foto: 'assets/images/dosen2.png',
  ),
  Dosen(
    id: '3',
    nama: 'HERY AFRIYADI, SE., S.Kom,M.Si',
    jabatan: '197104152000121001',
    email: 'HeryAfriyadi@uin.jambi.ac.id',
    phone: '+62 822-9876-1234',
    office: 'Ruang Prodi SI Lt. 4',
    mataKuliah: [
      'Testing & Implementasi Sistem',
      'Pengantar Ilmu Komputer',
      'Pengantar Bisnis & Manajemen',
      'Metodologi Penelitian & Riset'
    ],
    color: Color.fromARGB(255, 42, 120, 13),
    foto: 'assets/images/dosen3.png',
  ),
];
