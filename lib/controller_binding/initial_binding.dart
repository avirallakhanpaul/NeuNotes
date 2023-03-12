import 'package:get/get.dart';

import 'package:neunotes/controllers/note_controller.dart';
import 'package:neunotes/controllers/theme_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ThemeController(), fenix: true);
    Get.lazyPut(() => NoteController());
  }
}
