// TODO fix this so it is a reusable widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const CustomList({ Key? key, required this.snapshot }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var post = snapshot.data!.docs[index];
                        return Card(
                          borderOnForeground: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          color: Colors.blue[200],
                          child: ListTile(
                              title: Text(post['date']),
                              trailing: Text(post['item_count'].toString()),
                              onTap:() async {
                                Navigator.pushNamed(
                                  context, 'details', 
                                  arguments: {'image': post['url'], 
                                  'title': post['date'], 
                                  'item_count': post['item_count'],
                                  'lattitude': post['lattitude'],
                                  'longitude': post['longitude']
                                  });
                              } ,
                          ),
                        );
                      },
                    );
  }
}