import 'package:flutter/material.dart';

class DividerPlusText extends StatelessWidget {
  final String text;
  const DividerPlusText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children:[
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey[500],
          ),
        ),
        Text(
// Text part
          text,
          style: TextStyle(color: Colors.grey[600]),
        ),
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }
}