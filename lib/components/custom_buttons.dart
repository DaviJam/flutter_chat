import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    this.text,
    this.color = Colors.white,
    @required this.onPressed,
  });
  final String text;
  final Color color;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: this.onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            this.text,
          ),
        ),
      ),
    );
  }
}
