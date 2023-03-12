import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/custom/colors.dart';

class NoteDescription extends StatefulWidget {
  final NoteController noteController;
  final String? noteDescription;
  final bool? isNewNote;

  const NoteDescription({
    required this.noteController,
    this.noteDescription,
    required this.isNewNote,
    super.key,
  });

  @override
  State<NoteDescription> createState() => _NoteDescriptionState();
}

class _NoteDescriptionState extends State<NoteDescription> {
  final GlobalKey<FormState> _descriptionKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    setDescription();
    super.initState();
  }

  void setDescription() {
    // If note is just created
    if (widget.isNewNote!) {
      _descriptionController.text = "";
    }
    // If an existing note is opened
    else {
      _descriptionController.text = widget.noteDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    void changeDescriptionField(String? value) {
      // If the note is just created
      if (widget.isNewNote! && value != "") {
        _descriptionController.text = value!;
        // Setting the cursor position
        _descriptionController.selection =
            TextSelection.collapsed(offset: value.length);
      }
      // If the title gets empty in an existing note
      else if (!widget.isNewNote! &&
          _descriptionController.text == widget.noteDescription &&
          value == "") {
        _descriptionController.text = "";
      }
      // If the title is not empty and is not equal to its original/previous title
      else if (value != "" && value != widget.noteDescription) {
        _descriptionController.text = value!;
        _descriptionController.selection =
            TextSelection.collapsed(offset: value.length);
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
      ),
      child: Form(
        key: _descriptionKey,
        child: TextField(
          keyboardAppearance:
              Get.isDarkMode ? Brightness.dark : Brightness.light,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "CabinetGrotesk",
            fontWeight: FontWeight.w700,
            color: Get.isDarkMode ? neuBackground : black,
            height: 1.3,
          ),
          scrollPadding: const EdgeInsets.all(0.0),
          controller: _descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Type something...",
          ),
          onChanged: (value) {
            changeDescriptionField(value);
            widget.noteController.submitDescription(value);
          },
        ),
      ),
    );
  }
}
