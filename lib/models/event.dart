/// A single calendar event with a title and optional description.
/// Events are identified by a unique [id] for future editing/deletion.
class Event {
  final String id;
  final String title;
  final String description;

  const Event({
    required this.id,
    required this.title,
    this.description = '',
  });
}
