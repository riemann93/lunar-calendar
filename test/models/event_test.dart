import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/models/event.dart';

void main() {
  group('Event', () {
    test('has required id and title', () {
      const event = Event(id: '123', title: 'Test Event');

      expect(event.id, '123');
      expect(event.title, 'Test Event');
    });

    test('description defaults to empty string', () {
      const event = Event(id: '123', title: 'Test Event');

      expect(event.description, '');
    });

    test('description is settable', () {
      const event = Event(
        id: '123',
        title: 'Test Event',
        description: 'Some details',
      );

      expect(event.description, 'Some details');
    });

    test('can be constructed as const', () {
      // Verifies the const constructor works correctly
      const event1 = Event(id: '1', title: 'A');
      const event2 = Event(id: '1', title: 'A');

      expect(event1.id, event2.id);
      expect(event1.title, event2.title);
    });
  });
}
