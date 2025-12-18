import 'package:flutter/material.dart';
import 'note.dart';

class NoteFormPage extends StatefulWidget {
  final Note? existingNote;

  const NoteFormPage({
    super.key,
    this.existingNote,
  });

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _title;
  late TextEditingController _content;
  late String _category;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(
      text: widget.existingNote?.title ?? '',
    );
    _content = TextEditingController(
      text: widget.existingNote?.content ?? '',
    );
    _category = widget.existingNote?.category ?? 'Kuliah';
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      Note(
        title: _title.text,
        content: _content.text,
        category: _category,
        createdAt: widget.existingNote?.createdAt ?? DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingNote == null
              ? 'Catatan Baru'
              : 'Edit Catatan',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                ),
                validator: (v) =>
                    v!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Kuliah',
                    child: Text('Kuliah'),
                  ),
                  DropdownMenuItem(
                    value: 'Organisasi',
                    child: Text('Organisasi'),
                  ),
                  DropdownMenuItem(
                    value: 'Pribadi',
                    child: Text('Pribadi'),
                  ),
                  DropdownMenuItem(
                    value: 'Lain-lain',
                    child: Text('Lain-lain'),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    _category = v!;
                  });
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TextFormField(
                  controller: _content,
                  expands: true,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Isi Catatan',
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Isi tidak boleh kosong' : null,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
