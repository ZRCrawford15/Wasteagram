// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:test/components/details_layout.dart';

class Details extends StatelessWidget {
  const Details({Key? key}) : super(key: key);

  static const routeName = 'details';

  @override
  Widget build(BuildContext context) {
    final Map? receivedValue =
        ModalRoute.of(context)?.settings.arguments as Map?;
    return Scaffold(
      appBar: AppBar(),
      body: DetailsLayout(receivedValue: receivedValue)
    );
  }
}
