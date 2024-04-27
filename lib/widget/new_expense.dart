import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widget/input_fields/custom_date_selector.dart';
import 'package:expense_tracker/widget/input_fields/custom_input.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.addExpense});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleTextEditController = TextEditingController();
  final _amountTextEditController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDay = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDay,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData(BuildContext bottomSheetContext) {
    final amount = double.tryParse(_amountTextEditController.text);
    final validAmount = amount != null && amount > 0;
    final title = _titleTextEditController.text.trim();

    if (title.isEmpty || !validAmount || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please enter a valid title, amount and date!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'))
          ],
        ),
      );
      return;
    }

    setState(() {
      widget.addExpense(Expense(
        title: title,
        amount: amount,
        date: _selectedDate!,
        category: _selectedCategory,
      ));
    });
    Navigator.pop(bottomSheetContext);
  }

  @override
  void dispose() {
    _titleTextEditController.dispose();
    _amountTextEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    final Widget footerButtons = Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(
          width: 18,
        ),
        ElevatedButton(
          onPressed: () {
            _submitExpenseData(context);
          },
          child: const Text('Save Expense'),
        ),
      ],
    );

    return LayoutBuilder(builder: (ctx, constraints) {
      final width = constraints.maxWidth;
      return SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, keyboardSpace + 16),
            child: Column(
              children: [
                if (width > 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomInput(
                        title: 'Title',
                        textEditController: _titleTextEditController,
                      ),
                      const SizedBox(width: 24),
                      CustomInput(
                        title: 'Amount',
                        prefix: '\$ ',
                        textEditController: _amountTextEditController,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      CustomInput(
                        title: 'Title',
                        textEditController: _titleTextEditController,
                      ),
                    ],
                  ),
                if (width > 600)
                  Row(
                    children: [
                      DropdownButton(
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        value: _selectedCategory,
                      ),
                      const SizedBox(
                        width: 34,
                      ),
                      CustomDateSelector(
                        selectedDate: _selectedDate,
                        onPressDatePicker: _presentDatePicker,
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      CustomInput(
                        title: 'Amount',
                        prefix: '\$ ',
                        textEditController: _amountTextEditController,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomDateSelector(
                        selectedDate: _selectedDate,
                        onPressDatePicker: _presentDatePicker,
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 16,
                ),
                if (width > 600)
                  footerButtons
                else
                  Row(
                    children: [
                      DropdownButton(
                        items: Category.values
                            .map(
                              (category) => DropdownMenuItem(
                                value: category,
                                child: Text(
                                  category.name.toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                        value: _selectedCategory,
                      ),
                      Expanded(child: footerButtons),
                    ],
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
