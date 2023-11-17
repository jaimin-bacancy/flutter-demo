import 'package:flutter/material.dart';

class FormDatePicker extends StatefulWidget {
  final String label;
  final DateTime selectedDate;
  final Function selectDate;

  const FormDatePicker({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.selectDate,
  });

  @override
  State<FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.selectDate(context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 18, bottom: 18),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black45,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text("${widget.selectedDate.toLocal()}".split(' ')[0]),
          )
        ],
      ),
    );
  }
}
