import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final Function(String) onSaved;
  final String regEx;
  final String hintText;
  final bool obscureText;

  CustomTextFormField(
      {required this.onSaved,
      required this.regEx,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      onSaved: (_val){
        onSaved(_val!);
      },
      obscureText: obscureText,
      validator: (val){
        return RegExp(regEx).hasMatch(val!) ? null : 'Enter Valid Input';
      },
      decoration: InputDecoration(
        fillColor: const Color.fromRGBO(30,29,37,1.0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54,),
      ),
    );
  }
}
