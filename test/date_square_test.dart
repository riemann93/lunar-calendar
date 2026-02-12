import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/date_square.dart';

/// Helper to pump a DateSquare with given props inside a constrained layout.
Widget buildTestDateSquare({
  required int date,
  bool isSelected = false,
  required ValueChanged<int> onDateSelected,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 50,
        height: 50,
        child: DateSquare(
          date: date,
          isSelected: isSelected,
          onDateSelected: onDateSelected,
        ),
      ),
    ),
  );
}

void main() {
  group('DateSquare', () {
    testWidgets('displays the date number', (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 7,
        onDateSelected: (_) {},
      ));

      expect(find.text('7'), findsOneWidget);
    });

    testWidgets('calls onDateSelected with correct date when tapped',
        (tester) async {
      int? tappedDate;
      await tester.pumpWidget(buildTestDateSquare(
        date: 15,
        onDateSelected: (d) => tappedDate = d,
      ));

      await tester.tap(find.text('15'));
      expect(tappedDate, 15);
    });

    testWidgets('shows default background color when not selected',
        (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 1,
        onDateSelected: (_) {},
      ));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DateSquare),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFE8D5D0));
    });

    testWidgets('shows selected background color when isSelected is true',
        (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 1,
        isSelected: true,
        onDateSelected: (_) {},
      ));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DateSquare),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFB89090));
    });

    testWidgets('shows white text when selected', (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 5,
        isSelected: true,
        onDateSelected: (_) {},
      ));

      final text = tester.widget<Text>(find.text('5'));
      expect(text.style!.color, Colors.white);
    });

    testWidgets('shows muted text color when not selected', (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 5,
        onDateSelected: (_) {},
      ));

      final text = tester.widget<Text>(find.text('5'));
      expect(text.style!.color, const Color(0xFF9D8B8B));
    });

    testWidgets('changes background color on hover', (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 3,
        onDateSelected: (_) {},
      ));

      // Create a mouse hover gesture
      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(DateSquare)));
      await tester.pump();

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(DateSquare),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, const Color(0xFFD4C4C0));
    });

    testWidgets('uses click cursor', (tester) async {
      await tester.pumpWidget(buildTestDateSquare(
        date: 1,
        onDateSelected: (_) {},
      ));

      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(DateSquare),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(mouseRegion.cursor, SystemMouseCursors.click);
    });
  });
}
