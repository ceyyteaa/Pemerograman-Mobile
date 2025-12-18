import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';
import 'note_form_page.dart';

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onToggleTheme;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> _notes = [];
  String _selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Kuliah',
    'Organisasi',
    'Pribadi',
    'Lain-lain',
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // ================== SHARED PREFERENCES ==================
  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('notes');

    if (data != null) {
      final List decoded = jsonDecode(data);
      setState(() {
        _notes = decoded.map((e) => Note.fromMap(e)).toList();
      });
    }
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(_notes.map((e) => e.toMap()).toList());
    await prefs.setString('notes', encoded);
  }

  // ================== FILTER ==================
  List<Note> get filteredNotes {
    if (_selectedCategory == 'Semua') return _notes;
    return _notes
        .where((note) => note.category == _selectedCategory)
        .toList();
  }

  // ================== ICON KATEGORI ==================
  IconData _iconForCategory(String category) {
    switch (category) {
      case 'Kuliah':
        return Icons.school;
      case 'Organisasi':
        return Icons.group;
      case 'Pribadi':
        return Icons.person;
      default:
        return Icons.star;
    }
  }

  // ================== CRUD ==================
  Future<void> _addNote() async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (_) => const NoteFormPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _notes.add(result);
      });
      _saveNotes();
    }
  }

  Future<void> _editNote(int index) async {
    final result = await Navigator.push<Note>(
      context,
      MaterialPageRoute(
        builder: (_) => NoteFormPage(
          existingNote: filteredNotes[index],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        final realIndex = _notes.indexOf(filteredNotes[index]);
        _notes[realIndex] = result;
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.remove(filteredNotes[index]);
    });
    _saveNotes();
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Notes'),
        actions: [
          Switch(
            value: widget.isDark,
            onChanged: widget.onToggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Filter Kategori',
                border: OutlineInputBorder(),
              ),
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
          Expanded(
            child: filteredNotes.isEmpty
                ? const Center(
                    child: Text('Belum ada catatan ✨'),
                  )
                : ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading:
                              Icon(_iconForCategory(note.category)),
                          title: Text(note.title),
                          subtitle: Text(
                            '${note.category} • ${note.createdAt.toLocal().toString().split(' ')[0]}\n${note.content}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: true,
                          onTap: () => _editNote(index),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteNote(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
