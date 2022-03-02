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
  final num? total_items = 0;
  File? image;
  final picker = ImagePicker();

/*
* Pick an image from the gallery, upload it to Firebase Storage and return 
* the URL of the image in Firebase Storage.
*/


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wasteagram')
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
                        return ListTile(
                            leading: Text(post['weight'].toString()),
                            title: Text(post['title']),
                            //trailing: Image.network(post['url']),
                            onTap:() async {
                              Navigator.pushNamed(context, 'details', arguments: {'image': post['url']});
                            } ,

                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    child: Text('New Post!'),
                    onPressed: () async {
                      // getImage();
                      Navigator.pushNamed(context, 'NewEntry', arguments: {'image':                       await getImage()});
                      // navigate to new new entry and pass the picture taken
                    },
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Center(child: CircularProgressIndicator()),
                  ElevatedButton(
                    child: Text('New Post!'),
                    onPressed: () async {
                      // getImage();
                      Navigator.pushNamed(context, 'NewEntry', arguments: {'image':                       await getImage()});
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
