import "package:flutter/material.dart";
import 'Authentication.dart';
import 'DialogBox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';
import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatefulWidget {
  HomePage({
    this.auth,
    this.onSignedOut,
  });

  final AuthImplemention auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> postList = [];

  @override
  void initState() {
    super.initState();

    DatabaseReference postsRef =
        FirebaseDatabase.instance.reference().child("Posts");

    postsRef.once().then((DataSnapshot snap) async {
      var KEYS = snap.value.keys;
      var DATA = snap.value;
      postList.clear();

      for (var eachKEY in KEYS) {
        Posts posts = new Posts(
          DATA[eachKEY]["image"],
          DATA[eachKEY]["description"],
          DATA[eachKEY]["date"],
          DATA[eachKEY]["time"],
        );

        postList.add(posts);
      }
      setState(() {
        print('Lenght : $postList.length');
      });
    });
  }

  DialogBox dialogBox = new DialogBox();

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 16.0);
  }

  void _logoutUser() async {
    try {
      await widget.auth.SignOut();
      widget.onSignedOut();
      toastMessage("LogOut Successful");
    } catch (e) {
      dialogBox.informtion(context, "Error", e.toString());
      print("error : " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(
          "Blog Store",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: new Container(
        color: Colors.white,
        child: postList.length == 0
            ? Center(
                child: new Text(
                  "No Blog Post Available",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            : new ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return PostUI(
                      postList[index].image,
                      postList[index].description,
                      postList[index].date,
                      postList[index].time);
                },
              ),
      ),
      bottomNavigationBar: new BottomAppBar(
        child: new Container(
          color: Colors.orange[800],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.add_a_photo),
                iconSize: 40,
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new UploadPhoto();
                  }));
                },
              ),
              new IconButton(
                icon: Icon(Icons.exit_to_app),
                iconSize: 40,
                color: Colors.white,
                onPressed: _logoutUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostUI(String image, String description, String date, String time) {
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(15.0),
      child: new Container(
        padding: new EdgeInsets.all(15.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  date,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                ),
                new Text(
                  time,
                  style: Theme.of(context).textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            new Image.network(
              image,
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.0,
            ),
            new Text(
              description,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
