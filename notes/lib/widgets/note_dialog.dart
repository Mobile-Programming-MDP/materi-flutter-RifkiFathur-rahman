import 'dart:io';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/services/note_service.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;

  const NoteDialog{{super.key, this.note}};

  @override
  State<NoteDialog> createState() => _NoteDialogState();
}

class _NoteDialogState extends State<NoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _imageFile;
}

@override
void initState() {
  super.initState();
  if (widget.note !=null) {
    _titleController.text = widget.note!.title;
    _descriptionController.text = widget.note!.description;
  }
}