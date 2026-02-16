import 'package:flutter/material.dart';
import 'date_square.dart';

class MonthCard extends StatefulWidget {
  final String monthName;
  final int daysInMonth;
  final int startWeekday; // 0=Sun, 6=Sat — offset for first day of month
  final int? todayDay;
  final bool Function(int day)? hasEventOnDay;

  const MonthCard({
    super.key,
    required this.monthName,
    this.daysInMonth = 28,
    this.startWeekday = 0,
    this.todayDay,
    this.hasEventOnDay,
  });

  @override
  State<MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<MonthCard> {
  int? selectedDate;

  // Day of week headers
  static const List<String> dayHeaders = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    final totalCells = widget.startWeekday + widget.daysInMonth;

    return Semantics(
      label: widget.monthName,
      container: true,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EDE8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month name
            Text(
              widget.monthName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xFF7D6B6B),
              ),
            ),
            const SizedBox(height: 16),

            // Day headers
            Row(
              children: dayHeaders.map((day) {
                return Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9D8B8B),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),

            // Date grid
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: totalCells,
                itemBuilder: (context, index) {
                  // Empty cells for weekday offset
                  if (index < widget.startWeekday) {
                    return const SizedBox.shrink();
                  }
                  final dateNumber = index - widget.startWeekday + 1;
                  return DateSquare(
                    date: dateNumber,
                    isSelected: selectedDate == dateNumber,
                    isToday: widget.todayDay == dateNumber,
                    hasEvent: widget.hasEventOnDay?.call(dateNumber) ?? false,
                    onDateSelected: (date) {
                      setState(() {
                        selectedDate = selectedDate == date ? null : date;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
