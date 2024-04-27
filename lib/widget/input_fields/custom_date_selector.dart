import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class CustomDateSelector extends StatelessWidget {
  const CustomDateSelector({
    super.key,
    required this.selectedDate,
    required this.onPressDatePicker,
  });

  final DateTime? selectedDate;
  final void Function() onPressDatePicker;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            selectedDate != null
                ? formatter.format(selectedDate!)
                : 'No Date Selected',
          ),
          IconButton(
            onPressed: onPressDatePicker,
            icon: const Icon(Icons.date_range),
          )
        ],
      ),
    );
  }
}
