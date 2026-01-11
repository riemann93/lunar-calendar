import 'package:flutter/material.dart';

class DateSquare extends StatefulWidget {
  final int date;
  final bool isSelected;
  final Function(int) onDateSelected;

  const DateSquare({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onDateSelected,
  });

  @override
  State<DateSquare> createState() => _DateSquareState();
}

class _DateSquareState extends State<DateSquare> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Determine background color based on state
    Color backgroundColor;
    if (widget.isSelected) {
      backgroundColor = const Color(0xFFB89090); // Dusty rose when selected
    } else if (isHovered) {
      backgroundColor = const Color(0xFFD4C4C0); // Darker when hovered
    } else {
      backgroundColor = const Color(0xFFE8D5D0); // Light peachy default
    }

    // Determine text color
    Color textColor = widget.isSelected
        ? Colors.white
        : const Color(0xFF9D8B8B);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          widget.onDateSelected(widget.date);
        },
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              widget.date.toString(),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
