import 'package:flutter/material.dart';

mixin GeneralWidgets {
  static Widget textFieldGeneral(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.black12,
      ),
    );
  }

  static Widget textFieldWithIconGeneral(
      {required String hintText,
      required IconData icon,
      required TextEditingController text}) {
    return TextField(
      controller: text,
      decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Colors.black12,
          icon: Icon(icon)),
    );


  }
}
