import 'package:flutter/material.dart';
import 'date_square.dart';

class MonthCard extends StatefulWidget {
  final String monthName;

  const MonthCard({super.key, required this.monthName});

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

            // Date grid - 28 dates in 4 rows of 7
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: 28,
                itemBuilder: (context, index) {
                  int dateNumber = index + 1;
                  return DateSquare(
                    date: dateNumber,
                    isSelected: selectedDate == dateNumber,
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
