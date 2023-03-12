import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/custom/colors.dart';
import 'package:neunotes/models/note_model.dart';
import 'package:neunotes/pages/home_page/home_page.dart';
import 'package:neunotes/services/vibration_service.dart';
import 'package:share_plus/share_plus.dart';

class OptionMenu extends StatelessWidget {
  final bool? isNewNote;
  final Note? note;
  final NoteController? noteController;

  const OptionMenu({this.isNewNote, this.note, this.noteController, super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return FocusedMenuHolder(
      menuWidth: mediaQuery.width * 0.175,
      menuItemExtent: mediaQuery.width * 0.165,
      blurSize: 0.0,
      blurBackgroundColor: Colors.transparent,
      onPressed: () => VibrationService(impact: VibrationImpact.light),
      openWithTap: true,
      animateMenuItems: true,
      menuItems: <FocusedMenuItem>[
        // COPY
        FocusedMenuItem(
          onPressed: () async {
            VibrationService(impact: VibrationImpact.light);
            await Clipboard.setData(
              ClipboardData(text: noteController!.description),
            );
            Get.snackbar(
              "",
              "Description copied to clipboard",
              snackStyle: SnackStyle.GROUNDED,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Color(noteController!.color.value),
              borderWidth: 5,
              borderColor: black,
              borderRadius: 2.0,
              colorText: black,
              isDismissible: true,
              margin: const EdgeInsets.all(16.0),
              duration: const Duration(seconds: 2),
              padding: const EdgeInsets.only(
                left: 18.0,
                top: 14.0,
                right: 18.0,
                bottom: 18.0,
              ),
              boxShadows: <BoxShadow>[
                const BoxShadow(
                  blurRadius: 0.0,
                  color: black,
                  offset: Offset(5.0, 5.0),
                ),
              ],
              icon: SvgPicture.asset(
                "assets/icons/Copy.svg",
              ),
              titleText: const Text(
                "",
                style: TextStyle(
                  fontSize: 0.0,
                ),
              ),
              messageText: const Text(
                "Description copied to clipboard",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  color: black,
                ),
              ),
            );
          },
          title: Transform.scale(
            alignment: Alignment.center,
            scale: mediaQuery.width * 0.0035,
            child: SvgPicture.asset("assets/icons/Copy.svg"),
          ),
          backgroundColor: neuBackground,
        ),
        // SHARE
        FocusedMenuItem(
          onPressed: () async {
            VibrationService(impact: VibrationImpact.light);
            if ((noteController!.title == null ||
                    noteController!.title == "") &&
                (noteController!.description == null ||
                    noteController!.description == "")) {
              Get.snackbar(
                "Can't share empty note",
                "Add a title and description to continue",
                snackStyle: SnackStyle.GROUNDED,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color(noteController!.color.value),
                borderWidth: 5,
                borderColor: black,
                borderRadius: 2.0,
                colorText: black,
                isDismissible: true,
                margin: const EdgeInsets.all(16.0),
                duration: const Duration(seconds: 3),
                padding: const EdgeInsets.only(
                  left: 18.0,
                  top: 14.0,
                  right: 12.0,
                  bottom: 14.0,
                ),
                icon: SvgPicture.asset(
                  "assets/icons/Information.svg",
                ),
                boxShadows: <BoxShadow>[
                  const BoxShadow(
                    blurRadius: 0.0,
                    color: black,
                    offset: Offset(5.0, 5.0),
                  ),
                ],
                titleText: const Text(
                  "Can't share empty note",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w900,
                    color: black,
                  ),
                ),
                messageText: const Text(
                  "Add a title and description to continue",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w900,
                    color: black,
                  ),
                ),
              );
            } else if ((noteController!.title != null &&
                    noteController!.description != null) &&
                isNewNote!) {
              await Share.share(
                noteController!.description ?? "Created with Neu Notes ❤",
                subject: noteController!.title ?? "",
              );
            } else {
              await Share.share(
                "${noteController!.title}\n\n${noteController!.description}\n\nCreated with Neu Notes ❤",
                subject: noteController!.title,
              );
            }
          },
          title: Transform.scale(
            alignment: Alignment.center,
            scale: mediaQuery.width * 0.0035,
            child: SvgPicture.asset("assets/icons/Share.svg"),
          ),
          backgroundColor: neuBackground,
        ),
        // DELETE
        FocusedMenuItem(
          onPressed: () async {
            VibrationService(impact: VibrationImpact.light);
            if (note == null) {
              await noteController?.deleteNote(null, isNullNote: true);
            } else {
              final isDeleted = await noteController?.deleteNote(note!);
              isDeleted!
                  ? Get.off(
                      () => const HomePage(),
                      transition: Transition.size,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                    )
                  : null;
            }
          },
          title: Transform.scale(
            alignment: Alignment.center,
            scale: mediaQuery.width * 0.0035,
            child: SvgPicture.asset("assets/icons/Delete.svg"),
          ),
          backgroundColor: neuBackground,
        ),
        // COLOR
        FocusedMenuItem(
          onPressed: () {},
          title: FocusedMenuHolder(
            onPressed: () => VibrationService(impact: VibrationImpact.light),
            openWithTap: true,
            menuWidth: mediaQuery.width * 0.175,
            menuItemExtent: mediaQuery.width * 0.165,
            blurSize: 1.0,
            menuOffset: 5.0,
            animateMenuItems: true,
            menuItems: <FocusedMenuItem>[
              // Yellow Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuYellow.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuYellow,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Blue Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuBlue.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuBlue,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Green Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuGreen.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuGreen,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Purple Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuPurple.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuPurple,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Orange Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuOrange.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuOrange,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Red Color
              FocusedMenuItem(
                onPressed: () {
                  noteController!.submitColor(
                    neuRed.value,
                    setColor: true,
                  );
                },
                title: CircleAvatar(
                  child: Container(
                    decoration: BoxDecoration(
                      color: neuRed,
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: black,
                        width: 3.0,
                      ),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          blurRadius: 0.0,
                          offset: Offset(3.0, 3.0),
                          color: black,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            child: Transform.scale(
              alignment: Alignment.center,
              scale: mediaQuery.width * 0.0025,
              child: CircleAvatar(
                child: GetX<NoteController>(
                  builder: (controller) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Color(controller.color.value),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: black,
                          width: 3.0,
                        ),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            blurRadius: 0.0,
                            offset: Offset(3.0, 3.0),
                            color: black,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          backgroundColor: neuBackground,
        ),
      ],
      child: Transform.scale(
        alignment: Alignment.centerLeft,
        scale: mediaQuery.width * 0.003,
        child: SvgPicture.asset("assets/icons/Options.svg"),
      ),
    );
  }
}
