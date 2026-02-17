import 'package:flutter/foundation.dart';
import 'ifc_date.dart';

/// A calendar event, stored against a Gregorian date (source of truth).
/// Events are identified by a unique [id] for editing/deletion.
@immutable
class Event {
  final String id;
  final String title;
  final DateTime date;
  final String description;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    this.description = '',
  });

  @override
  bool operator ==(Object other) => other is Event && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Simple in-memory event store, indexed by Gregorian date for quick lookup.
class EventStore {
  final Map<String, List<Event>> _events = {};

  static String _key(DateTime date) =>
      '${date.year}-${date.month}-${date.day}';

  void add(Event event) {
    final key = _key(event.date);
    _events.putIfAbsent(key, () => []).add(event);
  }

  void remove(String id) {
    for (final list in _events.values) {
      list.removeWhere((e) => e.id == id);
    }
    _events.removeWhere((_, v) => v.isEmpty);
  }

  /// Get events for a Gregorian date.
  List<Event> forDate(DateTime date) {
    return _events[_key(date)] ?? const [];
  }

  /// Get events for an IFC date (converts to Gregorian first).
  List<Event> forIfcDate(IfcDate ifcDate) {
    return forDate(ifcDate.toDateTime());
  }

  bool hasEvents(DateTime date) => forDate(date).isNotEmpty;

  List<Event> get all => _events.values.expand((e) => e).toList();
}
