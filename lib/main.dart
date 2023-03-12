import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:get_storage/get_storage.dart";

import 'package:neunotes/controller_binding/initial_binding.dart';
import "package:neunotes/controllers/theme_controller.dart";
import "package:neunotes/pages/home_page/home_page.dart";
import "package:neunotes/pages/note_page/note_page.dart";
import "package:neunotes/services/db_service.dart";
import "package:neunotes/services/theme_service.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbService.initDb();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const NeuNotes());
  });
}

class NeuNotes extends StatelessWidget {
  const NeuNotes({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: ThemeService().lightThemeData,
      darkTheme: ThemeService().darkThemeData,
      themeMode: ThemeController().theme,
      getPages: <GetPage>[
        GetPage(
          name: "/",
          page: () => const HomePage(),
        ),
        GetPage(
          name: "/note",
          page: () => const NotePage(),
        ),
      ],
      home: const HomePage(),
    );
  }
}
