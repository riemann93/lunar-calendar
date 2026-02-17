import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/models/event.dart';
import 'package:lunar_calendar/models/ifc_date.dart';

void main() {
  group('Event', () {
    test('equality is based on id', () {
      final a = Event(id: '1', title: 'Birthday', date: DateTime(2026, 2, 5));
      final b = Event(id: '1', title: 'Different', date: DateTime(2026, 3, 1));
      expect(a, b);
    });

    test('different ids are not equal', () {
      final a = Event(id: '1', title: 'A', date: DateTime(2026, 2, 5));
      final b = Event(id: '2', title: 'A', date: DateTime(2026, 2, 5));
      expect(a == b, false);
    });

    test('description defaults to empty string', () {
      final event = Event(
        id: '123',
        title: 'Test Event',
        date: DateTime(2026, 1, 1),
      );
      expect(event.description, '');
    });

    test('description is settable', () {
      final event = Event(
        id: '123',
        title: 'Test Event',
        date: DateTime(2026, 1, 1),
        description: 'Some details',
      );
      expect(event.description, 'Some details');
    });
  });

  group('EventStore', () {
    late EventStore store;

    setUp(() {
      store = EventStore();
    });

    test('add and retrieve event by Gregorian date', () {
      final event = Event(
        id: '1',
        title: 'Birthday',
        date: DateTime(2026, 2, 5),
      );
      store.add(event);

      final results = store.forDate(DateTime(2026, 2, 5));
      expect(results.length, 1);
      expect(results.first.title, 'Birthday');
    });

    test('retrieve event by IFC date', () {
      // Feb 5 Gregorian = IFC Feb 8
      final event = Event(
        id: '1',
        title: 'Birthday',
        date: DateTime(2026, 2, 5),
      );
      store.add(event);

      final ifcDate = IfcDate(year: 2026, month: 1, day: 8);
      final results = store.forIfcDate(ifcDate);
      expect(results.length, 1);
      expect(results.first.title, 'Birthday');
    });

    test('hasEvents returns true when events exist', () {
      store.add(Event(id: '1', title: 'Test', date: DateTime(2026, 3, 15)));
      expect(store.hasEvents(DateTime(2026, 3, 15)), true);
      expect(store.hasEvents(DateTime(2026, 3, 16)), false);
    });

    test('remove event by id', () {
      store.add(Event(id: '1', title: 'A', date: DateTime(2026, 1, 1)));
      store.add(Event(id: '2', title: 'B', date: DateTime(2026, 1, 1)));
      store.remove('1');

      final results = store.forDate(DateTime(2026, 1, 1));
      expect(results.length, 1);
      expect(results.first.id, '2');
    });

    test('remove cleans up empty date entries', () {
      store.add(Event(id: '1', title: 'A', date: DateTime(2026, 5, 10)));
      store.remove('1');
      expect(store.hasEvents(DateTime(2026, 5, 10)), false);
      expect(store.all, isEmpty);
    });

    test('multiple events on the same date', () {
      store.add(Event(id: '1', title: 'A', date: DateTime(2026, 7, 4)));
      store.add(Event(id: '2', title: 'B', date: DateTime(2026, 7, 4)));

      expect(store.forDate(DateTime(2026, 7, 4)).length, 2);
    });

    test('all returns flat list of every event', () {
      store.add(Event(id: '1', title: 'A', date: DateTime(2026, 1, 1)));
      store.add(Event(id: '2', title: 'B', date: DateTime(2026, 6, 15)));
      expect(store.all.length, 2);
    });
  });
}
