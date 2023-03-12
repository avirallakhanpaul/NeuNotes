import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neunotes/custom/colors.dart';

import 'package:neunotes/models/note_model.dart';
import 'package:neunotes/pages/home_page/home_page.dart';
import 'package:neunotes/services/db_service.dart';
import 'package:neunotes/services/neu_font_service.dart';
import 'package:neunotes/services/vibration_service.dart';

class NoteController extends GetxController {
  List<Note>? noteList = <Note>[].obs;
  List<Note>? selectedNoteList = <Note>[].obs;

  // bool selected = false;

  String? title;
  String? description;
  RxInt color = neuYellow.value.obs;

  void submitTitle(String? value) {
    title = value;
  }

  void submitDescription(String? value) {
    description = value;
  }

  void submitColor(int value, {bool setColor = false}) {
    color.value = value;
    setColor
        ? Get.snackbar(
            "Color will update once note is saved",
            "",
            snackStyle: SnackStyle.GROUNDED,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(value),
            borderWidth: 5,
            borderColor: black,
            borderRadius: 2.0,
            colorText: black,
            isDismissible: true,
            margin: const EdgeInsets.all(16.0),
            duration: const Duration(seconds: 3),
            padding: const EdgeInsets.symmetric(
              vertical: 14.0,
              horizontal: 18.0,
            ),
            icon: SvgPicture.asset(
              "assets/icons/Done.svg",
            ),
            titleText: const Text(
              "Color will update once note is saved",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
                color: black,
              ),
            ),
            messageText: Container(),
            boxShadows: <BoxShadow>[
              const BoxShadow(
                blurRadius: 0.0,
                color: black,
                offset: Offset(5.0, 5.0),
              ),
            ],
          )
        : null;
    VibrationService(impact: VibrationImpact.light);
  }

  Future<void> fetchNotes() async {
    List<Map<String, Object?>> notes = await DbService.query();
    noteList?.assignAll(notes.map((data) => Note.fromJson(data)).toList());
  }

  Future<void> addNote(Note note) async {
    await DbService.insertToDb(note);
    fetchNotes();
    title = null;
    description = null;
  }

  Future<bool> deleteNote(Note? note, {bool isNullNote = false}) async {
    bool? isDeleted;
    await Get.dialog(
      AlertDialog(
        title: NeuFont(
          text:
              isNullNote ? "Delete (unnamed note)?" : "Delete ${note!.title}?",
          type: NeuType.h1,
          color: neuRed,
        ),
        content: NeuFont(
          text: isNullNote
              ? "This will permanently delete (unnamed note) from your device."
              : "This will permanently delete ${note!.title} from your device.",
          type: NeuType.h4,
        ),
        backgroundColor: Get.isDarkMode ? neuBackgroundDark : neuBackground,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        actionsPadding: const EdgeInsets.all(22.0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  isDeleted = false;
                  Get.back();
                },
                child: Transform.scale(
                  scale: Get.width * 0.004,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/Back.svg",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // If title and description are null, in case of a newly created note
                  if (isNullNote) {
                    Get.offAll(
                      () => const HomePage(),
                      transition: Transition.size,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeOut,
                    );
                  } else {
                    VibrationService(impact: VibrationImpact.light);
                    await DbService.delete(note!);
                    fetchNotes();
                  }
                  Get.back();
                  isDeleted = true;
                },
                child: Transform.scale(
                  scale: Get.width * 0.004,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/Delete.svg",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    return isDeleted!;
  }

  Future<void> deleteSelectedNotes() async {
    await Get.dialog(
      AlertDialog(
        title: NeuFont(
          text: "Delete notes (${selectedNoteList!.length})?",
          type: NeuType.h1,
          color: neuRed,
        ),
        content: NeuFont(
          text:
              "This will permanently delete ${selectedNoteList!.length} note(s) from your device.",
          type: NeuType.h4,
        ),
        backgroundColor: Get.isDarkMode ? neuBackgroundDark : neuBackground,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        actionsPadding: const EdgeInsets.all(22.0),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  VibrationService(impact: VibrationImpact.light);
                  Get.back();
                  selectedNoteList!.clear();
                  update();
                },
                child: Transform.scale(
                  scale: Get.width * 0.004,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/Back.svg",
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  VibrationService(impact: VibrationImpact.light);
                  for (int index = 0;
                      index < selectedNoteList!.length;
                      index++) {
                    await DbService.delete(selectedNoteList![index]);
                  }
                  Get.back();
                  selectedNoteList!.clear();
                  update();
                  fetchNotes();
                },
                child: Transform.scale(
                  scale: Get.width * 0.004,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: SvgPicture.asset(
                      "assets/icons/Delete.svg",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> updateNote(Note note) async {
    await DbService.update(note);
    fetchNotes();
  }

  void selectNote(String id) {
    selectedNoteList?.add(noteList!.firstWhere((n) => n.id == id));
    update();
  }

  void deselectNote(String id) {
    selectedNoteList?.remove(noteList!.firstWhere((n) => n.id == id));
    update();
  }
}
