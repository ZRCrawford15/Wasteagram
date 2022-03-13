// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class DetailsLayout extends StatelessWidget {
  final receivedValue;
  const DetailsLayout({ Key? key, required this.receivedValue }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  receivedValue!['title'],
                  style: Theme.of(context).textTheme.headline6,
                )),
            Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue,
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 3))
                    ]),
                child: Image.network(receivedValue['image'])),
            Container(
              padding: EdgeInsets.all(15),
              margin: EdgeInsets.all(15),
              child: Text(
                  'Number of items: ${receivedValue['item_count'].toString()}',
                  style: Theme.of(context).textTheme.headline6),
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Text(
                    'Location: (${receivedValue['lattitude']}, ${receivedValue['longitude']})'))
          ],
        ),
    );
  }
}