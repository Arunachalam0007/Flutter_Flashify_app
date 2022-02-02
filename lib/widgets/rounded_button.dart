import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final double height;
  final double width;
  final String btnName;
  final VoidCallback onPressed;

  const RoundedButton(
      {required this.height,
      required this.width,
      required this.btnName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: TextButton(
        child: Text(
          btnName,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 22,
            height: 1.5,
          ),
        ),
        onPressed: onPressed,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 82, 218, 1.0),
        borderRadius: BorderRadius.circular(height * 0.25),
      ),
    );
  }
}
