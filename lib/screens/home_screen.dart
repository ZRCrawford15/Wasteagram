import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../components/custom_list.dart';


class HomeScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<HomeScreen> {
  File? image;
  final picker = ImagePicker();
  num totalCount = 0;

  @override
  void initState() {
    super.initState();
    getTotalItemCount();
  }

/*
* Pick an image from the gallery, upload it to Firebase Storage and return 
* the URL of the image in Firebase Storage.
*/

@override
Widget build(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
    builder: (context,  AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasData &&
      snapshot.data!.docs != null &&
      snapshot.data!.docs.isNotEmpty) {
        return Scaffold(
        appBar: AppBar(
        title: Center(child: Text('Wasteagram - $totalCount'))),
        body: Column(
                children: [
                  Expanded(
                    child: CustomList(snapshot: snapshot)
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 50,
                    child: ElevatedButton(
                      child: const Icon(Icons.camera),
                      onPressed: () async {
                        String url = await getImage();
                        Navigator.pushNamed(
                          context, 'NewEntry', 
                          arguments: {'image': url});
                        // navigate to new new entry and pass the picture taken
                      },
                    ),
                  ),
                ],
              )
            );
      } else {  // empty list
      return Scaffold(
        appBar: AppBar(
        title: Center(child: Text('Wasteagram - 0'))),
        body: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Center(child: CircularProgressIndicator()),
                    Container(
                    margin: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: 50,
                      child: ElevatedButton(
                        child: const Icon(Icons.camera),
                        onPressed: () async {
                          Navigator.pushNamed(
                            context, 'NewEntry', 
                            arguments: {'image': await getImage()});
                          // navigate to new new entry and pass the picture taken
                        },
                      ),
                    ),
                  ],
                ),
        )
            );
      }
    }
  );
}


    Future getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera,
      maxHeight: 550,
      maxWidth: 300);
      return pickedFile!.path;
  }

  // trying to initalize item count for header
  getTotalItemCount() {
    StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.length > 0) {
                  ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var post = snapshot.data!.docs[index];
                          totalCount += (post['item_count']);
                          return Card();
                    });
                }
                return Card();
      });
  }
}