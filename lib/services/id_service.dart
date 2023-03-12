import 'package:uuid/uuid.dart';

class IdService {
  final Uuid _uuid = const Uuid();

  String generateId() {
    return _uuid.v1().toString();
  }
}
