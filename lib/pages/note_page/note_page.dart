import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/custom/colors.dart';
import 'package:neunotes/models/note_model.dart';
import 'package:neunotes/pages/home_page/home_page.dart';
import 'package:neunotes/pages/note_page/widgets/note_description.dart';
import 'package:neunotes/pages/note_page/widgets/note_title.dart';
import 'package:neunotes/pages/note_page/widgets/option_menu.dart';
import 'package:neunotes/services/id_service.dart';

class NotePage extends StatelessWidget {
  final NoteController? noteController;
  final Note? note;
  final int? noteIndex;
  final bool? isNewNote;

  const NotePage({
    this.noteController,
    this.note,
    this.noteIndex,
    this.isNewNote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    void backToHome() {
      HapticFeedback.lightImpact();
      Get.offAll(
        () => const HomePage(),
        transition: Transition.size,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    }

    Future<bool> saveOrUpdate() async {
      String? titleText = noteController!.title;
      String? descriptionText = noteController!.description;

      if (isNewNote!) {
        // If note is totally empty
        if ((titleText == null && descriptionText == null) ||
            (titleText == "" && descriptionText == "")) {
          backToHome();
          // If a note has something in either the title or the description
        } else {
          noteController?.addNote(
            Note(
              id: IdService().generateId(),
              title: noteController?.title ?? "Title",
              description: noteController?.description ?? "",
              color: noteController?.color.value ?? neuYellow.value,
            ),
          );
        }
      }
      // If title and description are empty in an existing note
      else if (!isNewNote! && (titleText == "" && descriptionText == "")) {
        await noteController?.deleteNote(note);
        backToHome();
      }
      // Update Note Title and title is not empty
      else if (note?.title != titleText && titleText != "") {
        noteController?.updateNote(
          Note(
            id: note?.id,
            title: titleText!,
            description: descriptionText ?? note!.description,
            color: noteController!.color.value,
          ),
        );
        // Update Note Title and title is empty
      } else if (note?.title != titleText && titleText == "") {
        noteController?.updateNote(
          Note(
            id: note?.id,
            title: "Title",
            description: descriptionText ?? note!.description,
            color: noteController!.color.value,
          ),
        );
      }
      // Update Note Description
      else if (note?.description != descriptionText) {
        noteController?.updateNote(
          Note(
            id: note?.id,
            title: titleText ?? note!.title,
            description: descriptionText!,
            color: noteController!.color.value,
          ),
        );
        // Update Note Color
      } else if (note?.color != noteController!.color.value) {
        noteController?.updateNote(
          Note(
            id: note?.id,
            title: titleText ?? note!.title,
            description: descriptionText ?? note!.description,
            color: noteController!.color.value,
          ),
        );
      } else {
        backToHome();
      }
      backToHome();
      return true;
    }

    return WillPopScope(
      onWillPop: saveOrUpdate,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(noteController!.color.value),
          toolbarHeight: mediaQuery.height * 0.1,
          elevation: 0.0,
          title: NoteTitle(
            noteController: noteController!,
            noteTitle: note?.title,
            isNewNote: isNewNote,
          ),
          leading: Transform.scale(
            alignment: Alignment.centerLeft,
            scale: mediaQuery.width * 0.003,
            child: IconButton(
              icon: SvgPicture.asset("assets/icons/Back.svg"),
              onPressed: saveOrUpdate,
              iconSize: 36.0,
              splashRadius: 28.0,
            ),
          ),
          actions: [
            Transform.scale(
              alignment: Alignment.centerRight,
              scale: mediaQuery.width * 0.003,
              child: IconButton(
                icon: SvgPicture.asset("assets/icons/Done.svg"),
                onPressed: saveOrUpdate,
                iconSize: 36.0,
                splashRadius: 28.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 6.0,
                right: 18.0,
              ),
              child: OptionMenu(
                isNewNote: isNewNote,
                note: note,
                noteController: noteController,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 1.0),
            child: Divider(
              color: Get.isDarkMode ? neuBackground : black,
              height: 1.0,
              thickness: 3.0,
            ),
          ),
        ),
        body: NoteDescription(
          noteController: noteController!,
          noteDescription: note?.description,
          isNewNote: isNewNote,
        ),
      ),
    );
  }
}
