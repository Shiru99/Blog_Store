import 'package:blog_store/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadPhoto extends StatefulWidget {
  @override
  _UploadPhotoState createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  File sampleImage;
  String _myValue;
  String url;
  final formKey = new GlobalKey<FormState>();

  bool validateANDsave() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    }
    return false;
  }

  void uploadStatusImage() async {
    if (validateANDsave()) {
      final StorageReference postImgReference =
          FirebaseStorage.instance.ref().child("Post Images");
      var timeKey = new DateTime.now();
      final StorageUploadTask uploadTask = postImgReference
          .child(timeKey.toString() + ".jpg")
          .putFile(sampleImage);

      var ImgURL = await (await uploadTask.onComplete).ref.getDownloadURL();

      url = ImgURL.toString();
      print("Image URL : " + url);

      saveToDatabase(url);
      goToHomePage();
    }
  }

  void goToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new HomePage();
    }));
  }

  void saveToDatabase(url) {
    var dbTimeKey = new DateTime.now();
    var formateDate = new DateFormat("MMM d, yyyy");
    var formateTime = new DateFormat("EEEE, hh:mm aaa");

    String date = formateDate.format(dbTimeKey);
    String time = formateTime.format(dbTimeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();

    var data = {
      "image": url,
      "description": _myValue,
      "date": date,
      "time": time,
    };

    ref.child("Posts").push().set(data);
  }

  Future getImage() async {
    // var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    PickedFile tempImage = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    setState(() {
      sampleImage = File(tempImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      // resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        title: new Text("Upload Blog"),
      ),
      body: new Center(
        child: sampleImage == null
            ? Text("First Select an Image")
            : enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Add Image',
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget enableUpload() {
    return Container(
      child: new Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            Image.file(
              sampleImage,
              height: 330.0,
              width: 660.0,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextFormField(
              autocorrect: true,
              decoration: new InputDecoration(
                labelText: "Description",
              ),
              validator: (value) {
                return value.isEmpty ? 'Blog Description is required*' : null;
              },
              onSaved: (value) {
                return _myValue = value;
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              elevation: 10.0,
              child: Text("Add a new Post"),
              textColor: Colors.white,
              color: Colors.orange,
              onPressed: uploadStatusImage,
            )
          ],
        ),
      ),
    );
  }
}
