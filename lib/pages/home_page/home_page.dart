import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/controllers/theme_controller.dart';

import 'package:neunotes/custom/colors.dart';
import 'package:neunotes/pages/home_page/widgets/date_widget.dart';
import 'package:neunotes/pages/note_page/note_page.dart';
import 'package:neunotes/services/neu_font_service.dart';
import 'package:neunotes/services/nue_container_service.dart';
import 'package:neunotes/services/vibration_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final controller = Get.find<NoteController>();
    controller.fetchNotes();

    void addNote() {
      VibrationService(impact: VibrationImpact.light);
      controller.submitTitle(null);
      controller.submitDescription(null);
      controller.submitColor(neuYellow.value);
      Get.to(
        () => NotePage(
          isNewNote: true,
          noteController: controller,
          // existingNoteOpened: false,
        ),
        transition: Transition.circularReveal,
        duration: const Duration(milliseconds: 600),
        curve: Curves.linearToEaseOut,
      );
    }

    Future<void> buildInfoPopUp() async {
      VibrationService(impact: VibrationImpact.light);
      await Get.defaultDialog(
        backgroundColor: Get.isDarkMode ? appBarDark : neuBackground,
        radius: 10.0,
        title: "",
        titlePadding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0.0),
        content: Column(
          children: <Widget>[
            const NeuFont(
              text: "NeuNotes",
              type: NeuType.h1,
              color: neuYellow,
            ),
            const SizedBox(height: 14.0),
            Divider(
              color: Get.isDarkMode ? neuBackground : black,
              thickness: 2.0,
            ),
            const SizedBox(height: 14.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Designed & Developed by",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "CabinetGrotesk",
                    fontWeight: FontWeight.w700,
                    color: Get.isDarkMode ? white : black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: NeuFont(
                  text: "Aviral Lakhanpaul",
                  type: NeuType.h1,
                  color: neuBlue,
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Divider(
              color: Get.isDarkMode ? neuBackground : black,
              thickness: 2.0,
            ),
            const SizedBox(height: 8.0),
            Text(
              "Made with ❤ and hardwork",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "CabinetGrotesk",
                fontWeight: FontWeight.w700,
                color: Get.isDarkMode ? neuBackground : black,
              ),
            ),
          ],
        ),
      );
    }

    Widget buildNotes() {
      if (controller.noteList!.isEmpty) {
        return GetBuilder<ThemeController>(
          builder: (themeController) {
            return Expanded(
              child: Transform.translate(
                offset: Offset(0.0, mediaQuery.width * 0.2),
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: addNote,
                      child: SvgPicture.asset(
                        "assets/illustrations/empty_state.svg",
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Create your first note!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        color: themeController.isDarkTheme ? white : black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    themeController.isDarkTheme
                        ? Transform.translate(
                            offset: Offset(mediaQuery.width * 0.24, 0.0),
                            child: SvgPicture.asset(
                                "assets/illustrations/arrow_dark.svg"),
                          )
                        : Transform.translate(
                            offset: Offset(mediaQuery.width * 0.24, 0.0),
                            child: SvgPicture.asset(
                                "assets/illustrations/arrow_light.svg"),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        return Expanded(
          child: ListView.separated(
            separatorBuilder: (ctx, i) {
              return const SizedBox(
                height: 24.0,
              );
            },
            padding: const EdgeInsets.only(
              top: 0.0,
              right: 14.0,
              bottom: 24.0,
              left: 12.0,
            ),
            itemCount: controller.noteList!.length,
            itemBuilder: (context, index) {
              return NeuContainer(
                noteController: controller,
                itemIndex: index,
                id: controller.noteList![index].id!,
                selected: false,
                text: controller.noteList![index].title,
                color: controller.noteList![index].color!,
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: mediaQuery.height * 0.1,
        elevation: 0.0,
        title: const NeuFont(
          text: "NeuNotes",
          color: neuYellow,
          type: NeuType.h1,
        ),
        centerTitle: true,
        leading: GetBuilder<ThemeController>(builder: (controller) {
          return controller.isDarkTheme
              ? Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: mediaQuery.width * 0.0036,
                  child: IconButton(
                    icon: SvgPicture.asset("assets/icons/Light_Theme.svg"),
                    onPressed: () {
                      VibrationService(impact: VibrationImpact.light);
                      controller.toggleTheme();
                    },
                    splashRadius: 28.0,
                  ),
                )
              : Transform.scale(
                  alignment: Alignment.centerLeft,
                  scale: mediaQuery.width * 0.0036,
                  child: IconButton(
                    icon: SvgPicture.asset("assets/icons/Dark_Theme.svg"),
                    onPressed: () {
                      VibrationService(impact: VibrationImpact.light);
                      controller.toggleTheme();
                    },
                    splashRadius: 28.0,
                  ),
                );
        }),
        actions: <Widget>[
          GetBuilder<NoteController>(
            builder: (controller) {
              return controller.selectedNoteList!.isNotEmpty
                  ? Transform.scale(
                      alignment: Alignment.centerRight,
                      scale: mediaQuery.width * 0.004,
                      child: IconButton(
                        icon: SvgPicture.asset("assets/icons/Delete.svg"),
                        onPressed: () {
                          VibrationService(impact: VibrationImpact.light);
                          controller.deleteSelectedNotes();
                        },
                        splashRadius: 28.0,
                      ),
                    )
                  : Transform.scale(
                      alignment: Alignment.centerRight,
                      scale: mediaQuery.width * 0.004,
                      child: IconButton(
                        icon: SvgPicture.asset("assets/icons/Information.svg"),
                        onPressed: buildInfoPopUp,
                        splashRadius: 28.0,
                      ),
                    );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 1.0),
          child: GetBuilder<ThemeController>(builder: (controller) {
            return Divider(
              color: controller.isDarkTheme ? neuBackground : black,
              height: 1.0,
              thickness: 3.0,
            );
          }),
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: mediaQuery.width * 0.004,
        alignment: Alignment.bottomRight,
        child: IconButton(
          icon: SvgPicture.asset("assets/icons/Add.svg"),
          splashRadius: 36.0,
          padding: const EdgeInsets.all(0.0),
          onPressed: addNote,
        ),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 48.0,
            child: Center(child: DateWidget()),
          ),
          GetBuilder<ThemeController>(builder: (controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(
                color: controller.isDarkTheme ? neuBackground : black,
                height: 1.0,
                thickness: 3.0,
              ),
            );
          }),
          const SizedBox(
            height: 16.0,
          ),
          Obx(() => buildNotes()),
        ],
      ),
    );
  }
}
