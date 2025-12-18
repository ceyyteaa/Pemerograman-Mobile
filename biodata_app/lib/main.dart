import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biodata App',
      home: Scaffold(
        backgroundColor: const Color(0xFFFFF0F5), // pink pastel lembut
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFB6C1), // pink pastel
          title: const Text(
            'Biodata Mahasiswa',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Nama : Cerry Noviyanti", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("NIM  : 701230042", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text(
                  "Hobi : Desain Grafis & Editing Video",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
