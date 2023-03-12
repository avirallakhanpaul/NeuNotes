import 'package:flutter/material.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/custom/colors.dart';

class NoteTitle extends StatefulWidget {
  final NoteController noteController;
  final String? noteTitle;
  final bool? isNewNote;

  const NoteTitle({
    required this.noteController,
    required this.noteTitle,
    required this.isNewNote,
    super.key,
  });

  @override
  State<NoteTitle> createState() => _NoteTitleState();
}

class _NoteTitleState extends State<NoteTitle> {
  final GlobalKey<FormState> _titleKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  void initState() {
    setTitle();
    super.initState();
  }

  void setTitle() {
    // If note is just created
    if (widget.isNewNote!) {
      _titleController.text = "";
    }
    // If an existing note is opened
    else {
      _titleController.text = widget.noteTitle!;
    }
  }

  @override
  Widget build(BuildContext context) {
    void changeTitleField(String? value) {
      // If the note is just created
      if (widget.isNewNote! && value != "") {
        _titleController.text = value!;
        // Setting the cursor position
        _titleController.selection =
            TextSelection.collapsed(offset: value.length);
      }
      // If the title gets empty in an existing note
      else if (!widget.isNewNote! &&
          _titleController.text == widget.noteTitle &&
          value == "") {
        _titleController.text = "";
      }
      // If the title is not empty and is not equal to its original/previous title
      else if (value != "" && value != widget.noteTitle) {
        _titleController.text = value!;
        _titleController.selection =
            TextSelection.collapsed(offset: value.length);
      }
    }

    return Form(
      key: _titleKey,
      child: TextField(
        enableSuggestions: true,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "CabinetGrotesk",
          fontWeight: FontWeight.w900,
          color: black,
          shadows: <Shadow>[
            Shadow(
              color: white,
              blurRadius: 0.0,
              offset: Offset(1, 1),
            ),
          ],
        ),
        controller: _titleController,
        maxLines: 1,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
        ),
        onChanged: (value) {
          changeTitleField(value);
          widget.noteController.submitTitle(value);
        },
      ),
    );
  }
}
