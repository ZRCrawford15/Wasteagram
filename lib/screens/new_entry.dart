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
  const NewEntry({Key? key}) : super(key: key);

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

  Post post = Post(
      dateTime: DateTime.now(),
      itemCount: 0,
      image: '',
      lattitude: '',
      longitude: '');

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    final Map? receivedValue =
        ModalRoute.of(context)?.settings.arguments as Map?;
    post.setImage = receivedValue!['image'];
    return Scaffold(
      appBar: AppBar(title: Text('Log a new post!')),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Semantics(
                  image: true,
                  child: Image.file(File(post.getImage)))
                ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(15),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Number of items',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            // TODO: Fix crash where numbers were entered then deleted
                            onChanged: (value) {
                              post.itemCount = int.parse(value);
                            },

                            //  validator not quite working right
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a value';
                              }
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * .1,
                child: Semantics(
                    button: true,
                    onTapHint: 'Upload your post',
                  child: ElevatedButton(
                      onPressed: () async {
                        post.lattitude = locationData!.latitude.toString();
                        post.longitude = locationData!.longitude.toString();
                        post.image = await getImage(post.getImage);
                        uploadData(post);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Upload!',
                        style: TextStyle(fontSize: 24),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void uploadData(Post post) async {
    String title = DateFormat('MM-dd-yyyy @ hh:mm a').format(DateTime.now());

    FirebaseFirestore.instance.collection('posts').add({
      'date': title,
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

  Future getImage(imageFile) async {
    final pickedFile = imageFile;
    image = File(pickedFile!);

    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference =
        FirebaseStorage.instance.ref().child(pickedFile);
    UploadTask uploadTask = storageReference.putFile(image!);
    await uploadTask;
    final url = await storageReference.getDownloadURL();
    return url;
  }
}



