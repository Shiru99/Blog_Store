import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'HomePage.dart';
import 'Authentication.dart';

class MappingPage extends StatefulWidget {
  final AuthImplemention auth;
  MappingPage({
    this.auth,
  });

  @override
  _MappingPageState createState() => _MappingPageState();
}

enum AuthStat {
  notSignedIn,
  signedIn,
}

class _MappingPageState extends State<MappingPage> {
  AuthStat authStat = AuthStat.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId) {
      setState(() {
        authStat =
            firebaseUserId == null ? AuthStat.notSignedIn : AuthStat.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStat = AuthStat.signedIn;
    });
  }

  void _signOut() {
    setState(() {
      authStat = AuthStat.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStat) {
      case AuthStat.notSignedIn:
        return new LoginPage(auth: widget.auth, onSignedIn: _signedIn);
      case AuthStat.signedIn:
        return new HomePage(auth: widget.auth, onSignedOut: _signOut);
    }
    return null;
  }
}
