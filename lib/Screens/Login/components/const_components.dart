import 'package:flutter/material.dart';

import '../../../constants.dart';

class ConstComponents {
  static const Widget loadingIndicator = SizedBox(
    height: 50,
    width: 50,
    child: Center(
      child: CircularProgressIndicator(
        color: kPrimaryColor,
        strokeWidth: 5,
      ),
    ),
  );
}
