import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;
  final IconData icon;

  CustomTextFormField(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText,
      required this.icon,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      onSaved: (_val) {
        onSaved(_val!);
      },
      obscureText: obscureText,
      validator: (val) {
        return RegExp(regEx).hasMatch(val!) ? null : 'Enter Valid Input';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white54,
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Function(String? val) onEditingComplete;
  final IconData icon;
  final TextEditingController? controller;
  CustomTextField({
    this.controller,
    required this.hintText,
    required this.obscureText,
    required this.icon,
    required this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: (val) {
        onEditingComplete(val);
      },
      // onEditingComplete: () {
      //   onEditingComplete(controller?.value.text);
      // },
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        fillColor: Color.fromRGBO(30, 29, 37, 1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white54,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.white54,
        ),
      ),
    );
  }
}
