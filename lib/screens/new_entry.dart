// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../models/post.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
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
  final Post post = Post(date: DateTime.now(), location: 'location', item_count: 0);
  String? image;
  // final String image_here = 'placeholder image spot';
  final picker = ImagePicker();
  num? items;
  DateTime? date;
  String? lattitude;
  String? longitude;
  

  LocationData? locationData;
  var locationService = Location();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }


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
                          // TODO use DTO 
                          // print(value);
                          items = int.parse(value);
                       },
                      )],
                    )
                  ],
                ),
              ),
              ElevatedButton(onPressed: () async {
                lattitude = locationData!.latitude.toString();  
                longitude = locationData!.longitude.toString();
                uploadData(image, items, lattitude, longitude);



                // trying to get the total_items collection avlue for updating
                // var collection = FirebaseFirestore.instance.collection('total_items');
                // var docSnapshot = await collection.doc('item_count').get();
                // if (docSnapshot.exists) {
                //   Map<String, dynamic> data = docSnapshot.data()!;
                //   var itemCount = data['item_count'];
                //   print(itemCount);
                // } else {
                //   print('No snapshot exists');
                // }
                Navigator.pop(context);
                
              }, child: Text('Upload!'))
            ],
          ),
        ),
      ),
    );
  }

  // pass DTO object instead
  void uploadData(image, itemCount, lat, long) async {
    DateTime date = DateTime.now();
    final url = image;
    final title = DateFormat.yMMMd().format(date);
    final numItems = itemCount;
    FirebaseFirestore.instance
        .collection('posts')
        .add({'title': title, 
              'url': url, 
              'item_count': numItems,
              'lattitude': lat,
              'longitude': long
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



}



