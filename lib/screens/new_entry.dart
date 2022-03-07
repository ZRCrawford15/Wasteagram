// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class NewEntry extends StatefulWidget {
  const NewEntry({ Key? key }) : super(key: key);

  static const routeName = 'NewEntry';

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {

  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? image;

  LocationData? locationData;
  var locationService = Location();

  Post post = Post(dateTime: DateTime.now(), itemCount: 0, 
    image: '', lattitude: '', longitude: '');

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }


  @override
  Widget build(BuildContext context) {
    final Map? receivedValue = ModalRoute.of(context)?.settings.arguments as Map?;
    post.setImage = receivedValue!['image'];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Expanded(child: Image.file(File(post.getImage))),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Number of items', 
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          post.itemCount = int.parse(value);
                       },
                      )],
                    )
                  ],
                ),
              ),
              ElevatedButton(onPressed: () async {
                post.lattitude = locationData!.latitude.toString();  
                post.longitude = locationData!.longitude.toString();
                uploadData(post);
                Navigator.pop(context);
                
              }, child: Text('Upload!'))
            ],
          ),
        ),
      ),
    );
  }

  void uploadData(Post post) async {
    String title = DateFormat('yyyy-MM-DD : kk:mm').format(DateTime.now());

    FirebaseFirestore.instance
        .collection('posts')
        .add({'date': title, 
              'url': post.getImage, 
              'item_count': post.getNumItems,
              'lattitude': post.getLattidue,
              'longitude': post.getLattidue
              });   
  }

void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    setState(() {});
  }


    Future getImage(imageUrl) async {
      // final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = imageUrl;

      var fileName = DateTime.now().toString() + '.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      final url = await storageReference.getDownloadURL();
      return url;
  }


}


