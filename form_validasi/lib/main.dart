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
      title: 'Form Mahasiswa Validasi',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo, // Warna tema utama
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.indigo, width: 2),
          ),
        ),
      ),
      home: const FormMahasiswaPage(),
    );
  }
}

class FormMahasiswaPage extends StatefulWidget {
  const FormMahasiswaPage({super.key});

  @override
  State<FormMahasiswaPage> createState() => _FormMahasiswaPageState();
}

class _FormMahasiswaPageState extends State<FormMahasiswaPage> {
  final _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  // FocusNodes
  final nameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();

  // Fields state
  String? jurusan;
  int semester = 1;
  Map<String, bool> hobbies = {
    'Olahraga': false,
    'Membaca': false,
    'Musik': false,
    'Programming': false,
  };
  bool agree = false;

  int _currentStep = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  bool _hobbySelectedAtLeastOne() {
    return hobbies.values.any((v) => v);
  }

  bool _validateStepSpecific(int step) {
    if (step == 1) {
      if (jurusan == null || jurusan!.isEmpty) {
        _showInlineError('Pilih jurusan pada langkah ini.');
        return false;
      }
      if (!_hobbySelectedAtLeastOne()) {
        _showInlineError('Pilih minimal satu hobi.');
        return false;
      }
      if (!agree) {
        _showInlineError('Anda harus menyetujui syarat & ketentuan.');
        return false;
      }
    }
    return true;
  }

  void _showInlineError(String msg) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onStepContinue() {
    final currentFormKey = _formKeys[_currentStep];
    if (currentFormKey.currentState != null &&
        currentFormKey.currentState!.validate()) {
      if (!_validateStepSpecific(_currentStep)) return;

      if (_currentStep < 2) {
        setState(() => _currentStep += 1);
      } else {
        _submitForm();
      }
    } else {
      _showInlineError('Periksa kembali input pada langkah ini.');
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _submitForm() {
    bool allValid = true;
    for (var i = 0; i < _formKeys.length; i++) {
      if (_formKeys[i].currentState != null &&
          !_formKeys[i].currentState!.validate()) {
        allValid = false;
      }
    }
    if (!_hobbySelectedAtLeastOne() || jurusan == null || !agree) {
      allValid = false;
    }

    if (!allValid) {
      _showInlineError('Form belum lengkap/valid.');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final selectedHobbies = hobbies.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .join(', ');
        return AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: const Text('Registrasi Berhasil'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                const SizedBox(height: 10),
                _buildSummaryText('Nama', nameController.text),
                _buildSummaryText('Email', emailController.text),
                _buildSummaryText('Jurusan', jurusan ?? '-'),
                const Divider(),
                Text(
                  'Hobi: $selectedHobbies',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetForm();
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black87, fontSize: 14),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      jurusan = null;
      semester = 1;
      hobbies.updateAll((key, value) => false);
      agree = false;
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final jurusanOptions = [
      'Teknik Informatika',
      'Sistem Informasi',
      'Teknik Elektro',
      'Manajemen',
      'Akuntansi',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pendaftaran Mahasiswa'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SafeArea(
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          elevation: 0,
          // Custom Controls (Tombol Lanjut/Kembali)
          controlsBuilder: (context, details) {
            final isLast = _currentStep == 2;
            return Container(
              margin: const EdgeInsets.only(top: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: details.onStepContinue,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(isLast ? 'Kirim Data' : 'Lanjut'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Kembali'),
                      ),
                    ),
                ],
              ),
            );
          },
          steps: [
            // STEP 1: Data Pribadi
            Step(
              title: const Text('Data Pribadi'),
              subtitle: const Text('Identitas dasar mahasiswa'),
              isActive: _currentStep >= 0,
              state: _currentStep > 0 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[0],
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      focusNode: nameFocus,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Nama wajib diisi';
                        if (value.trim().length < 2)
                          return 'Nama terlalu pendek';
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(emailFocus),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      focusNode: emailFocus,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Alamat Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Email wajib diisi';
                        if (!RegExp(
                          r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                        ).hasMatch(value.trim())) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(phoneFocus),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      focusNode: phoneFocus,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Nomor HP',
                        prefixIcon: Icon(Icons.phone_outlined),
                        hintText: '08...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Nomor HP wajib diisi';
                        final v = value.trim();
                        if (!RegExp(r'^[0-9]+$').hasMatch(v))
                          return 'Harus berupa angka';
                        if (v.length < 9 || v.length > 15)
                          return 'Panjang 9 - 15 digit';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // STEP 2: Akademik & Hobi
            Step(
              title: const Text('Akademik & Minat'),
              subtitle: const Text('Jurusan dan hobi'),
              isActive: _currentStep >= 1,
              state: _currentStep > 1 ? StepState.complete : StepState.indexed,
              content: Form(
                key: _formKeys[1],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: jurusan,
                      items: jurusanOptions
                          .map(
                            (j) => DropdownMenuItem(value: j, child: Text(j)),
                          )
                          .toList(),
                      decoration: const InputDecoration(
                        labelText: 'Pilih Jurusan',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      onChanged: (v) => setState(() => jurusan = v),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Wajib dipilih' : null,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Semester Saat Ini',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            semester.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      min: 1,
                      max: 8,
                      divisions: 7,
                      value: semester.toDouble(),
                      onChanged: (v) => setState(() => semester = v.toInt()),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pilih Hobi (Minimal 1)',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: hobbies.keys.map((h) {
                        return FilterChip(
                          label: Text(h),
                          selected: hobbies[h]!,
                          onSelected: (val) {
                            setState(() => hobbies[h] = val);
                          },
                        );
                      }).toList(),
                    ),
                    if (!_hobbySelectedAtLeastOne())
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '* Silakan pilih minimal satu hobi',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const Divider(height: 32),
                    InkWell(
                      onTap: () => setState(() => agree = !agree),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: agree
                              ? Border.all(color: Colors.transparent)
                              : Border.all(color: Colors.red.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              value: agree,
                              onChanged: (v) =>
                                  setState(() => agree = v ?? false),
                            ),
                            const Expanded(
                              child: Text(
                                'Saya menyetujui syarat & ketentuan berlaku.',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!agree)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          'Wajib disetujui',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // STEP 3: Konfirmasi
            Step(
              title: const Text('Konfirmasi'),
              isActive: _currentStep >= 2,
              state: _currentStep == 2 ? StepState.editing : StepState.indexed,
              content: Form(
                key: _formKeys[2],
                child: Card(
                  elevation: 0,
                  color: Theme.of(
                    context,
                  ).colorScheme.secondaryContainer.withOpacity(0.4),
                  margin: const EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Icon(
                            Icons.assignment_turned_in_outlined,
                            size: 40,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildConfirmationRow('Nama', nameController.text),
                        _buildConfirmationRow('Email', emailController.text),
                        _buildConfirmationRow('No HP', phoneController.text),
                        const Divider(),
                        _buildConfirmationRow('Jurusan', jurusan ?? '-'),
                        _buildConfirmationRow('Semester', semester.toString()),
                        _buildConfirmationRow(
                          'Hobi',
                          hobbies.entries
                                  .where((e) => e.value)
                                  .map((e) => e.key)
                                  .join(', ')
                                  .isEmpty
                              ? '-'
                              : hobbies.entries
                                    .where((e) => e.value)
                                    .map((e) => e.key)
                                    .join(', '),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.check_box,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Syarat & Ketentuan disetujui',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          const Text(':  '),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
