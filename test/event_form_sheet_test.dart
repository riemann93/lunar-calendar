import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/event_form_sheet.dart';
import 'package:lunar_calendar/models/event.dart';

/// Helper to pump an EventFormSheet inside a MaterialApp.
Widget buildTestEventFormSheet({
  String monthName = 'Sol',
  int day = 14,
  DateTime? date,
  ValueChanged<Event>? onSave,
}) {
  return MaterialApp(
    home: Scaffold(
      body: EventFormSheet(
        monthName: monthName,
        day: day,
        date: date ?? DateTime(2026, 7, 1),
        onSave: onSave ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('EventFormSheet', () {
    testWidgets('displays header text', (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet());

      expect(find.text('New Event'), findsOneWidget);
    });

    testWidgets('shows date context', (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet(
        monthName: 'Sol',
        day: 14,
      ));

      expect(find.text('Sol 14'), findsOneWidget);
    });

    testWidgets('has title text field', (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet());

      expect(find.widgetWithText(TextField, 'Event title'), findsOneWidget);
    });

    testWidgets('has description text field', (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet());

      expect(
        find.widgetWithText(TextField, 'Description (optional)'),
        findsOneWidget,
      );
    });

    testWidgets('save button uses inactive color when title is empty',
        (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet());

      // Find the save button container by finding the GestureDetector
      // wrapping the "Save" text
      final saveButton = find.ancestor(
        of: find.text('Save'),
        matching: find.byType(Container),
      );
      // The innermost Container with decoration is the button
      final containers = tester.widgetList<Container>(saveButton);
      final buttonContainer = containers.firstWhere(
        (c) => c.decoration is BoxDecoration,
      );
      final dec = buttonContainer.decoration as BoxDecoration;
      expect(dec.color, const Color(0xFFC9ADAD)); // inactive
    });

    testWidgets('save button uses active color when title is entered',
        (tester) async {
      await tester.pumpWidget(buildTestEventFormSheet());

      // Enter a title
      await tester.enterText(
        find.widgetWithText(TextField, 'Event title'),
        'My Event',
      );
      await tester.pump();

      final saveButton = find.ancestor(
        of: find.text('Save'),
        matching: find.byType(Container),
      );
      final containers = tester.widgetList<Container>(saveButton);
      final buttonContainer = containers.firstWhere(
        (c) => c.decoration is BoxDecoration,
      );
      final dec = buttonContainer.decoration as BoxDecoration;
      expect(dec.color, const Color(0xFFB89090)); // active
    });

    testWidgets('tapping save calls onSave with correct data',
        (tester) async {
      Event? savedEvent;
      await tester.pumpWidget(buildTestEventFormSheet(
        onSave: (event) => savedEvent = event,
      ));

      await tester.enterText(
        find.widgetWithText(TextField, 'Event title'),
        'Birthday',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Description (optional)'),
        'Surprise party',
      );
      await tester.pump();

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(savedEvent, isNotNull);
      expect(savedEvent!.title, 'Birthday');
      expect(savedEvent!.description, 'Surprise party');
      expect(savedEvent!.id, isNotEmpty);
    });
  });
}
