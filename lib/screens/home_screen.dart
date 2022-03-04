import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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

/*
* Pick an image from the gallery, upload it to Firebase Storage and return 
* the URL of the image in Firebase Storage.
*/

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram ' + totalCount.toString())
        ,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.docs != null &&
                snapshot.data!.docs.length > 0) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data!.docs[index];
                        totalCount += (post['item_count']);  // Not properly adding counts. Don't know why
                        return ListTile(
                            title: Text(post['title']),
                            onTap:() async {
                              Navigator.pushNamed(context, 'details', arguments: {'image': post['url'], 'title': post['title'], 'item_count': post['item_count']});
                            } ,
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('New Post!'),
                    onPressed: () async {
                      // getImage();
                      Navigator.pushNamed(
                        context, 'NewEntry', 
                        arguments: {'image': await getImage()});
                      // navigate to new new entry and pass the picture taken
                    },
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  const Center(child: CircularProgressIndicator()),
                  ElevatedButton(
                    child: const Text('New Post!'),
                    onPressed: () async {
                      // getImage();
                      Navigator.pushNamed(
                        context, 'NewEntry', 
                        arguments: {'image': await getImage()});
                      // navigate to new new entry and pass the picture taken
                    },
                  ),
                ],
              );
            }
          }),
    );
  }

    Future getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = File(pickedFile!.path);

      var fileName = DateTime.now().toString() + '.jpg';
      Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageReference.putFile(image!);
      await uploadTask;
      final url = await storageReference.getDownloadURL();
      return url;
  }



}
