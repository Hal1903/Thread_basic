import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const DeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: IconButton(
        onPressed: onTap,
        icon: const Icon(Icons.delete),
      ),
    );
  }
}