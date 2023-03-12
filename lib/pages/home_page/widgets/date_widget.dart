import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import 'package:neunotes/services/neu_font_service.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String getDate() {
      var currentDate = DateTime.now();
      return DateFormat.yMMMMd("en_US").format(currentDate).toString();
    }

    return NeuFont(
      text: getDate(),
      type: NeuType.h4,
    );
  }
}
