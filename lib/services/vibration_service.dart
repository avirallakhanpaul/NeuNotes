import "package:flutter/services.dart";

enum VibrationImpact {
  light,
  medium,
  heavy,
}

class VibrationService {
  final VibrationImpact impact;

  VibrationService({required this.impact}) {
    vibrate();
  }

  void vibrate() {
    if (impact == VibrationImpact.light) {
      HapticFeedback.lightImpact();
    } else if (impact == VibrationImpact.medium) {
      HapticFeedback.mediumImpact();
    } else if (impact == VibrationImpact.heavy) {
      HapticFeedback.heavyImpact();
    }
  }
}
