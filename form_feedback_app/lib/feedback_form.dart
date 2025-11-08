import 'package:flutter/material.dart';
import 'feedback_result.dart';

class FeedbackFormPage extends StatefulWidget {
  const FeedbackFormPage({super.key});

  @override
  _FeedbackFormPageState createState() => _FeedbackFormPageState();
}

class _FeedbackFormPageState extends State<FeedbackFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _comment = '';
  int _rating = 3;

  final List<String> _ratingLabels = const [
    'Sangat Buruk',
    'Buruk',
    'Cukup',
    'Baik',
    'Sangat Baik'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FeedbackResultPage(
            name: _name,
            comment: _comment,
            rating: _rating,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Feedback'),
        backgroundColor: const Color.fromARGB(255, 51, 119, 255),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header UIN Jambi
              _buildUniversityHeader(),

              const SizedBox(height: 24),

              // Form Feedback
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul Form
                        const Center(
                          child: Text(
                            'FORMULIR FEEDBACK MAHASISWA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 51, 119, 255),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'UIN Sultan Thaha Saifuddin Jambi',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Input Nama
                        const Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Masukkan Nama Lengkap Anda',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: Icon(Icons.person_outline),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap Masukkan Nama Anda';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _name = value!;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Input Komentar
                        const Text(
                          'Komentar dan Saran',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText:
                                'Berikan komentar dan saran untuk penggunaan SIBESTI',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: Icon(Icons.comment_outlined),
                            alignLabelWithHint: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harap masukkan komentar dan saran';
                            }
                            if (value.length < 8) {
                              return 'Komentar minimal 8 karakter';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _comment = value!;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Input Rating
                        const Text(
                          'Rating Kepuasan',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Rating: $_rating/5',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB (255, 51, 119, 255),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRatingColor(_rating)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getRatingColor(_rating),
                                        ),
                                      ),
                                      child: Text(
                                        _ratingLabels[_rating - 1],
                                        style: TextStyle(
                                          color: _getRatingColor(_rating),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Slider(
                                  value: _rating.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  activeColor: _getRatingColor(_rating),
                                  inactiveColor: Colors.grey[300],
                                  label: _rating.toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      _rating = value.round();
                                    });
                                  },
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      return Icon(
                                        Icons.star_rounded,
                                        color: index < _rating
                                            ? Colors.amber
                                            : Colors.grey[300],
                                        size: 32,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Tombol Submit
                        ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 51, 119, 255),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 2,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_outlined, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Kirim Feedback',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget _buildUniversityHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 51, 119, 255), const Color.fromARGB(255, 59, 114, 253)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.blue,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Universitas
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Lingkaran luar
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                ),
                // Ikon akademik
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_rounded,
                      color: const Color.fromARGB(255, 51, 119, 255),
                      size: 30,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'UIN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 51, 119, 255),
                      ),
                    ),
                  ],
                ),
                // Elemen dekoratif
                Positioned(
                  top: 10,
                  child: Container(
                    width: 60,
                    height: 2,
                    color: const Color.fromARGB(255, 51, 119, 255),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    width: 60,
                    height: 2,
                    color: const Color.fromARGB(255, 51, 119, 255),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Nama Universitas
          const Column(
            children: [
              Text(
                'UNIVERSITAS ISLAM NEGERI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                'SULTAN THAHA SAIFUDDIN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'J A M B I',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Garis pemisah
          Container(
            height: 2,
            width: 100,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(height: 12),

          // Motto/Deskripsi
          const Text(
            'Kami harap anda akan terus berpartisipasi memanfaatkan SuthaSIBESTI untuk menunjang proses perkuliahan.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            'Formulir Feedback Penggunaan SIBESTI',
            style: TextStyle(
              fontSize: 11,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightBlue;
      case 5:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
