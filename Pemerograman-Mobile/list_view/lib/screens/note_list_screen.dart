import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final string = prefs.getString('notes');
    if (string != null) {
      final List decoded = jsonDecode(string);
      setState(() {
        notes = decoded.map((e) => Note.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString('notes', encoded);
  }

  void _addNote(String title, String content) {
    setState(() {
      notes.insert(
        0,
        Note(
          id: DateTime.now().toIso8601String(),
          title: title,
          content: content,
          createdAt: DateTime.now(),
        ),
      );
    });
    _saveNotes();
  }

  void _updateNote(int index, String title, String content) {
    setState(() {
      notes[index].title = title;
      notes[index].content = content;
    });
    _saveNotes();
  }

  void _deleteNote(int index) {
    final removed = notes[index];
    setState(() {
      notes.removeAt(index);
    });
    _saveNotes();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terhapus: ${removed.title}'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              notes.insert(index, removed);
            });
            _saveNotes();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  // dialog for add/edit
  void _showNoteDialog({int? index}) {
    final isEdit = index != null;
    final titleCtrl =
        TextEditingController(text: isEdit ? notes[index!].title : '');
    final contentCtrl =
        TextEditingController(text: isEdit ? notes[index].content : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Isi catatan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal')),
            ElevatedButton(
              onPressed: () {
                final t = titleCtrl.text.trim();
                final c = contentCtrl.text.trim();
                if (t.isEmpty || c.isEmpty) return;
                if (isEdit) {
                  _updateNote(index!, t, c);
                } else {
                  _addNote(t, c);
                }
                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus "${notes[index].title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteNote(index);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // main UI
  @override
  Widget build(BuildContext context) {
    // pastel pink color tokens
    final primary = const Color(0xFFEF9AA6); // soft pink
    final primaryContainer = const Color(0xFFF7D7DB);
    final onPrimary = Colors.white;
    final surface = Colors.white;
    final shadow = Colors.grey.withOpacity(0.15);

    return Scaffold(
      backgroundColor: primaryContainer,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryContainer,
        centerTitle: true,
        title: const Text('Catatanku', style: TextStyle(color: Colors.black87)),
        actions: [
          IconButton(
            tooltip: 'Total catatan',
            icon: const Icon(Icons.info_outline, color: Colors.black54),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Wrap(children: [
                    ListTile(
                      leading: CircleAvatar(
                          backgroundColor: primary,
                          child: const Icon(Icons.note, color: Colors.white)),
                      title: const Text('Total catatan'),
                      subtitle: Text('${notes.length} catatan tersimpan'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: primary),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Total: ${notes.length} catatan')));
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Ok'),
                    )
                  ]),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: notes.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: shadow,
                                blurRadius: 10,
                                offset: Offset(0, 6))
                          ]),
                      padding: const EdgeInsets.all(20),
                      child: Icon(Icons.note_add, size: 56, color: primary),
                    ),
                    const SizedBox(height: 18),
                    const Text('Belum ada catatan',
                        style: TextStyle(fontSize: 18, color: Colors.black54)),
                    const SizedBox(height: 6),
                    const Text('Tekan tombol + untuk menambahkan catatan baru',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black45)),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: notes.length,
                padding: const EdgeInsets.only(top: 8, bottom: 80),
                itemBuilder: (context, index) {
                  final n = notes[index];
                  return GestureDetector(
                    onTap: () => _showNoteDialog(index: index),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: shadow,
                              blurRadius: 8,
                              offset: const Offset(0, 6))
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        title: Text(n.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(n.content,
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 8),
                            Text(_formatDate(n.createdAt),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black45)),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () => _showDeleteConfirm(index),
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
