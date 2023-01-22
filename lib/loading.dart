import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() => runApp(Loading());

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.blueGrey[900],
        child: const SpinKitRipple(
          color: Colors.white,
          size: 200.0,
          duration: Duration(milliseconds: 1500),
        ),
      ),
    );
  }
}
