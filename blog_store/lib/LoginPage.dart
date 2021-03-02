import 'package:blog_store/Authentication.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'DialogBox.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    this.auth,
    this.onSignedIn,
  });

  final AuthImplemention auth;
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  DialogBox dialogBox = new DialogBox();

  final _formKey = new GlobalKey<FormState>();

  FormType _formType = FormType.login;

  String _username, _email, _password = "";

  // Methods

  bool validatANDsave() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // toastMessage("Username: $_username\nEmail: $_email");
      return true;
    } else {
      return false;
    }
  }

  void ValidateAndSubmit() async {
    if (validatANDsave()) {
      try {
        // print("In validate And Save");
        if (_formType == FormType.login) {
          String userId = await widget.auth.SignIn(_email, _password);
          print("Login user Id : " + userId);
          toastMessage("Login Successful");
        } else {
          // print("In validate And Save : Else");
          String userId = await widget.auth.SignUp(_email, _password);
          print("Signup user Id : " + userId);
          toastMessage("Signup Successful");
        }
        widget.onSignedIn();
      } catch (e) {
        // print("NOT NOT NOT");
        dialogBox.informtion(context, "Error", e.toString());
        print("Error : " + e.toString());
      }
    }
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        fontSize: 16.0);
  }

  void registerAccount() {
    // _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void loginAccount() {
    // _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }
  // ONE

  List<Widget> createInputs() {
    return [
      SizedBox(
        height: 20.0,
      ),
      logo(),
      SizedBox(
        height: 20.0,
      ),
      new TextFormField(
        decoration: new InputDecoration(
          labelText: "Username",
          hintText: "e.g.   Morgan",
        ),
        textInputAction: TextInputAction.next,
        // autofocus: true,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        validator: (username) {
          Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
          RegExp regex = new RegExp(pattern);
          if (username.isEmpty) {
            return 'Please enter some text';
          }
          if (!regex.hasMatch(username))
            return 'Invalid username';
          else
            return null;
        },
        onSaved: (username) => _username = username,
      ),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
          decoration: new InputDecoration(
            labelText: "Email",
            hintText: "e.g.   john.doe@gmail.com",
          ),
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          // validator: (value){
          //   return value.isEmpty?'Email is required.':null;
          // },
          validator: (email) {
            if (email.isEmpty) {
              return 'Please enter some text';
            }
            return EmailValidator.validate(email)
                ? null
                : "Invalid email address";
          },
          onSaved: (value) {
            return _email = value;
          }),
      SizedBox(
        height: 10.0,
      ),
      new TextFormField(
          obscureText: true,
          decoration: new InputDecoration(
            labelText: "Password",
            hintText: " a-z + A-Z + 0-9 + !@#\$&*~ ",
            suffixIcon: Icon(Icons.lock),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
          validator: (password) {
            Pattern pattern =
                // r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
            RegExp regex = new RegExp(pattern);
            if (password.isEmpty) {
              return 'Please enter some text';
            }
            if (password.length < 8) {
              return 'atleast 8 charater';
            }
            if (!regex.hasMatch(password))
              return 'Invalid password';
            else
              return null;
          },
          onSaved: (value) {
            return _password = value;
          }),
      SizedBox(
        height: 10.0,
      ),
    ];
  }

  // three

  List<Widget> createButtons() {
    if (_formType == FormType.login) {
      return [
        new RaisedButton(
          //   onPressed: () {
          //     if (_formKey.currentState.validate()) {
          //       _formKey.currentState.save();
          //       toastMessage("Username: $_username\nEmail: $_email");
          //     }
          //   },
          onPressed: ValidateAndSubmit,
          textColor: Colors.white,
          color: Colors.orange,
          child: new Text(
            "Login",
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        new FlatButton(
          onPressed: registerAccount,
          textColor: Colors.orange,
          // color: Colors.orange,
          child: new Text(
            "Not having an Account? Create Account ?",
            style: new TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        // SizedBox(
        //   height: MediaQuery.of(Context).viewInsets.bottom,
        // ),
      ];
    } else {
      return [
        new RaisedButton(
          //   onPressed: () {
          //     if (_formKey.currentState.validate()) {
          //       _formKey.currentState.save();
          //       toastMessage("Username: $_username\nEmail: $_email");
          //     }
          //   },
          onPressed: ValidateAndSubmit,
          textColor: Colors.white,
          color: Colors.orange,
          child: new Text(
            "Create Account",
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        new FlatButton(
          onPressed: loginAccount,
          textColor: Colors.orange,
          // color: Colors.orange,
          child: new Text(
            "Already have an Account? Login",
            style: new TextStyle(
              fontSize: 14.0,
            ),
          ),
        ),
        // final bottom = MediaQuery.of(context).viewInsets.bottom;
      ];
    }
  }

  // TWO

  Widget logo() {
    return new Hero(
        tag: 'hero',
        child: new CircleAvatar(
          backgroundColor: Colors.orange,
          radius: 100.0,
          child: Image.asset('images/logo.png'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15.0),
          child: new Form(
            key: _formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: createInputs() + createButtons(),
            ),
          ),
        ),
      ),
    );
  }
}
