import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final String docId;
  final String currentTitle;
  final String currentDesc;

  const EditNoteScreen({super.key, required this.docId, required this.currentTitle, required this.currentDesc});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDesc);
  }

  Future<void> updateNote() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('notes')
          .doc(widget.docId)
          .update({'title': _titleController.text.trim(), 'description': _descController.text.trim()});

      if (mounted) Navigator.pop(context);
    } catch (e) {
      print("Error updating: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Text("Edit Note"), backgroundColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(hintText: "Title", border: InputBorder.none),
              ),
              Expanded(
                child: TextField(
                  controller: _descController,
                  maxLines: null,
                  decoration: InputDecoration(hintText: "Description", border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: updateNote,
          backgroundColor: Color(0xff6A3EA1),
          child: Icon(Icons.save, color: Colors.white),
        ),
      ),
    );
  }
}
