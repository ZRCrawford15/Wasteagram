import 'dart:io';

class Post {
  DateTime dateTime;
  String lattitude;
  String longitude;
  num itemCount;
  String image;

  Post({required this.dateTime, required this.lattitude, required this.longitude, required this.itemCount, required this.image});

  set setDate (DateTime date) {
    dateTime = date;
  }

  set setLattitude(String latt) {
    lattitude = latt;
  }

  set setLongitude(String long) {
    longitude = long;
  }

  set setnumItems(num items) {
    itemCount = items;
  }

  set setImage(String imageURL) {
    image = imageURL;
  }

  DateTime get getDateTime => dateTime;

  String get getLattidue => lattitude;

  String get getLongitude => longitude;

  num get getNumItems => itemCount;

  String get getImage => image;

}