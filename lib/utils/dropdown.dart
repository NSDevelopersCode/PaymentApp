import 'package:flutter/material.dart';

class CustomDropdownFieldAgain extends StatelessWidget {
  final String? title;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownFieldAgain({
    Key? key,
    required this.items,
    required this.onChanged,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 13, vertical: 1), // Decrease vertical padding here
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(width: 0.5, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF323247).withOpacity(0.05),
                spreadRadius: 3,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              dropdownColor: Colors.grey.shade200,
              hint: Text(
                title ?? 'Select an option',
                style: const TextStyle(color: Colors.grey),
              ),
              value: value == "" ? null : value,
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
              iconSize: 24,
              elevation: 16,
              items: items.map((var item) {
                return DropdownMenuItem<String>(
                  value: item.toString(),
                  child: Text(item.toString(),
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.normal)),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
