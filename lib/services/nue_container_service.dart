import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/custom/colors.dart';
import 'package:neunotes/pages/note_page/note_page.dart';
import 'package:neunotes/services/neu_font_service.dart';
import 'package:neunotes/services/vibration_service.dart';

class NeuContainer extends StatelessWidget {
  @required
  final NoteController noteController;
  @required
  final int itemIndex;
  @required
  final String id;
  @required
  final bool selected;
  @required
  final String text;
  @required
  final int color;

  const NeuContainer({
    required this.noteController,
    required this.itemIndex,
    required this.id,
    required this.selected,
    required this.text,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    bool isSelected = selected;

    void openNote() {
      VibrationService(impact: VibrationImpact.light);
      noteController.submitColor(noteController.noteList![itemIndex].color!);
      noteController.submitTitle(noteController.noteList![itemIndex].title);
      noteController
          .submitDescription(noteController.noteList![itemIndex].description);
      Get.to(
        () => NotePage(
          noteController: noteController,
          note: noteController.noteList![itemIndex],
          isNewNote: false,
        ),
        transition: Transition.circularReveal,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    }

    return FocusedMenuHolder(
      onPressed: () {},
      openWithTap: false,
      menuWidth: mediaQuery.width * 0.165,
      menuItemExtent: mediaQuery.width * 0.165,
      blurSize: 1.0,
      menuOffset: 10.0,
      menuBoxDecoration: BoxDecoration(
        color: neuBackground,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            blurRadius: 0.0,
            color: black,
            offset: Offset(5, 5),
          ),
        ],
      ),
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
          onPressed: () async {
            VibrationService(impact: VibrationImpact.light);
            await Share.share(
              "${noteController.noteList![itemIndex].title}\n\n${noteController.noteList![itemIndex].description} \n\nCreated with Neu Notes ❤",
              subject: noteController.noteList![itemIndex].title,
            );
          },
          title: Transform.scale(
            alignment: Alignment.center,
            scale: mediaQuery.width * 0.004,
            child: SvgPicture.asset("assets/icons/Share.svg"),
          ),
          backgroundColor: neuBackground,
        ),
        FocusedMenuItem(
          onPressed: () {
            noteController.deleteNote(noteController.noteList![itemIndex]);
          },
          title: Transform.scale(
            alignment: Alignment.center,
            scale: mediaQuery.width * 0.004,
            child: SvgPicture.asset("assets/icons/Delete.svg"),
          ),
          backgroundColor: neuBackground,
        ),
      ],
      child: Container(
        decoration: BoxDecoration(
          color: Color(color),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: black,
            width: 4.0,
          ),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              blurRadius: 0.0,
              color: black,
              offset: Offset(5, 5),
            ),
          ],
        ),
        child: ListTile(
          leading: GetBuilder<NoteController>(
            builder: (controller) {
              isSelected = controller.selectedNoteList!
                  .contains(controller.noteList![itemIndex]);
              return IconButton(
                onPressed: () {
                  VibrationService(impact: VibrationImpact.light);
                  isSelected = !isSelected;
                  if (isSelected == true) {
                    controller.selectNote(id);
                  } else {
                    controller.deselectNote(id);
                  }
                },
                icon: controller.selectedNoteList!
                        .contains(controller.noteList![itemIndex])
                    ? SvgPicture.asset("assets/icons/Selected.svg")
                    : SvgPicture.asset("assets/icons/Unselected.svg"),
              );
            },
          ),
          title: NeuFont(
            text: text,
            type: NeuType.h3,
          ),
          trailing: IconButton(
            icon: SvgPicture.asset(
              "assets/icons/Open.svg",
            ),
            padding: const EdgeInsets.all(0.0),
            iconSize: 36.0,
            onPressed: openNote,
          ),
          horizontalTitleGap: 2.0,
          onTap: openNote,
          contentPadding: const EdgeInsets.only(
            top: 6.0,
            right: 10.0,
            bottom: 6.0,
            left: 5.0,
          ),
        ),
      ),
    );
  }
}
