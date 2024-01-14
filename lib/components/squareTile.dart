import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagePath;
  final Offset offset;
  final double h;
  const SquareTile({super.key, required this.imagePath, required this.h, this.offset=Offset.zero});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: h,
      // decoration: BoxDecoration(
      //   border: Border.all(),
      // ),
      child: Image.asset(
        imagePath,
        alignment: FractionalOffset(offset.dx, offset.dy),
      ),
    );
  }
}