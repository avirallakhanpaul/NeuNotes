class Note {
  final String? id;
  final String title;
  final String description;
  final int? color;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.color,
  });

  static Note fromJson(Map<Object, Object?> note) {
    return Note(
      id: note["id"].toString(),
      title: note["title"].toString(),
      description: note["description"].toString(),
      color: int.parse(note["color"].toString()),
    );
  }

  Map<String, Object> toJson(Note note) {
    return {
      "id": note.id!,
      "title": note.title,
      "description": note.description,
      "color": note.color!,
    };
  }
}
