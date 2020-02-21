import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';
import 'package:sso/sso.dart';

class FirebaseAppleAuthenticator
    with WillNotify, WillConvertUser
    implements Authenticator {
  final bool _isSupport = Platform.isIOS;

  @override
  WidgetBuilder get action => (context) => _isSupport
      ? ActionButton(
          onPressed: () => authenticate(context),
          color: Colors.black,
          textColor: Colors.white,
          icon: Image.asset("images/apple.png",
              package: "identity_firebase_apple", width: 24, height: 24),
          text: "Sign in with Apple")
      : Container();

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        notify(context, "Processing ...");
        final String idToken =
            String.fromCharCodes(result.credential.identityToken);
        final String accessToken =
            String.fromCharCodes(result.credential.authorizationCode);
        final OAuthProvider oAuthProvider =
            OAuthProvider(providerId: "apple.com");
        final AuthCredential credential = oAuthProvider.getCredential(
            idToken: idToken, accessToken: accessToken);

        return FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((result) => convert(result.user))
            .then((user) => Identity.of(context).user = user)
            .catchError(Identity.of(context).error);
      case AuthorizationStatus.cancelled:
        Identity.of(context).error("User cancelled!");
        break;
      case AuthorizationStatus.error:
        Identity.of(context).error("Unable to sign in!");
        break;
    }
  }
}
