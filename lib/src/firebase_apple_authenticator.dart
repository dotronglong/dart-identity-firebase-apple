import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

class FirebaseAppleAuthenticator implements Authenticator {

  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => authenticate(context),
      color: Color.fromRGBO(66, 103, 178, 1),
      textColor: Colors.white,
      icon: Image.asset("images/apple.png",
          package: "identity_firebase_apple", width: 24, height: 24),
      text: "Sign In With Apple");

  @override
  Future<Function> authenticate(BuildContext context, [Map parameters]) {

  }
}