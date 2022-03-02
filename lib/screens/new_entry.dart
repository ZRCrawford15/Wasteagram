// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../models/post.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({ Key? key }) : super(key: key);

  static const routeName = 'NewEntry';

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {

  final formKey = GlobalKey<FormState>();
  final Post post = Post(date: DateTime.now(), location: 'location', item_count: 0);
  String? image;
  // final String image_here = 'placeholder image spot';
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final Map? receivedValue = ModalRoute.of(context)?.settings.arguments as Map?;
    image = receivedValue!['image'];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Image.network(image!),
              // Text(image_here),
              Text('Form spot'),
              ElevatedButton(onPressed: () {
                uploadData(image);
                Navigator.pushNamed(context, '/');
              }, child: Text('Upload!'))
            ],
          ),
        ),
      ),
    );
  }

  void uploadData(image) async {
    final url = image;
    final date = DateTime.now().millisecondsSinceEpoch % 1000;
    final title = 'Title ' + date.toString();
    FirebaseFirestore.instance
        .collection('posts')
        .add({'weight': date, 'title': title, 'url': url});
  }
}



