import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:neunotes/controllers/theme_controller.dart';
import 'package:neunotes/custom/colors.dart';

enum NeuType { h1, h2, h3, h4 }

class NeuFont extends StatelessWidget {
  @required
  final String text;
  @required
  final Color color;
  @required
  final NeuType type;

  const NeuFont({
    required this.text,
    this.color = black,
    required this.type,
    super.key,
  });

  Stack generateNeuH1Font() {
    return Stack(
      children: <Text>[
        Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontFamily: "CabinetGrotesk",
            fontWeight: FontWeight.w900,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              // ..strokeWidth = 4.5
              ..strokeWidth = 4
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.miter
              ..color = black,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 24,
            fontFamily: "CabinetGrotesk",
            fontWeight: FontWeight.w900,
            color: color,
            shadows: const <Shadow>[
              Shadow(
                color: black,
                blurRadius: 0.0,
                offset: Offset(2.5, 2.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget generateNeuH2Font() {
    return Container();
    // final titleController = TextEditingController();

    // return TextField(
    //   style: const TextStyle(
    //     fontSize: 20,
    //     fontFamily: "CabinetGrotesk",
    //     fontWeight: FontWeight.w900,
    //     color: black,
    //     shadows: <Shadow>[
    //       Shadow(
    //         color: white,
    //         blurRadius: 0.0,
    //         offset: Offset(1, 1),
    //       ),
    //     ],
    //   ),
    //   controller: titleController,
    //   maxLines: 1,
    //   keyboardType: TextInputType.text,
    //   decoration: const InputDecoration(
    //     border: InputBorder.none,
    //     hintText: "Enter title",
    //   ),
    //   onSubmitted: (submittedText) {},
    // );
    // return Stack(
    //   children: <Text>[
    //     Text(
    //       text,
    //       style: TextStyle(
    //         fontSize: 20,
    //         fontFamily: "CabinetGrotesk",
    //         fontWeight: FontWeight.w900,
    //         foreground: Paint()
    //           ..style = PaintingStyle.stroke
    //           ..strokeWidth = 4
    //           ..strokeCap = StrokeCap.round
    //           ..strokeJoin = StrokeJoin.miter
    //           ..color = black,
    //       ),
    //     ),
    //   ],
    // );
  }

  Text generateNeuH3Font() {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 18,
        fontFamily: "CabinetGrotesk",
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }

  Widget generateNeuH4Font() {
    return GetBuilder<ThemeController>(builder: (controller) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "CabinetGrotesk",
          fontWeight: FontWeight.w700,
          color: controller.isDarkTheme ? neuBackground : black,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (type == NeuType.h1) {
      return generateNeuH1Font();
    } else if (type == NeuType.h2) {
      return generateNeuH2Font();
    } else if (type == NeuType.h3) {
      return generateNeuH3Font();
    } else {
      return generateNeuH4Font();
    }
  }
}
