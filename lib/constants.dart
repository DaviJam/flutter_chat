import 'package:flutter/material.dart';

String kRED(String str) {
  return '\x1B[31m$str\x1B[0m';
}

String kGRN(String str) {
  return '\x1B[32m$str\x1B[0m';
}

String kYEL(String str) {
  return '\x1B[33m$str\x1B[0m';
}

String kBLU(String str) {
  return '\x1B[34m$str\x1B[0m';
}

String kMAG(String str) {
  return '\x1B[35m$str\x1B[0m';
}

String kCYN(String str) {
  return '\x1B[36m$str\x1B[0m';
}

String kWHT(String str) {
  return '\x1B[37m$str\x1B[0m';
}

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'whatever text',
  hintStyle: TextStyle(
    color: Colors.black38,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  errorText: null,
);
