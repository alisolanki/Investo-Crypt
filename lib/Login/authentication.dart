import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  ConfirmationResult? _confirmationResult;
  String? _actualCode;

  Future<void> signInWithPhoneNumber(
    BuildContext context,
    String phoneNumber,
  ) async {
    phoneNumber = phoneNumber.trim();
    if (phoneNumber.length == 10) {
      phoneNumber = '+91' + phoneNumber;
    }
    if (kIsWeb) {
      // web
      try {
        final result = await _auth.signInWithPhoneNumber(phoneNumber);
        print(result.toString());
        _actualCode = result.verificationId;
        _confirmationResult = result;
        print('OTP sent successfully');
      } catch (e) {
        Fluttertoast.showToast(
          msg: e.toString(),
          backgroundColor: Colors.red,
        );
        throw (e);
      }
    } else {
      // mobile
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber.trim(),
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential auth) async {
            await _auth
                .signInWithCredential(auth)
                .then((UserCredential authResult) {
              if (authResult != null && authResult.user != null) {
                print('Authentication successful');
                onAuthenticationSuccessful(context, authResult.user!);
              } else {
                Fluttertoast.showToast(
                  msg: 'Invalid code/invalid authentication',
                );
              }
            }).catchError((_) {
              Fluttertoast.showToast(
                msg: 'Something has gone wrong, please try later',
              );
            });
          },
          verificationFailed: (FirebaseAuthException authException) {
            print('Error message: ' + authException.message!);
            Fluttertoast.showToast(
              msg:
                  'The phone number format is incorrect. Please enter your number in this format. [+][country code][number] eg.+919876543210',
            );
          },
          codeSent: (String verificationId, [int? forceResendingToken]) {
            _actualCode = verificationId;
            Modular.to.pushNamedAndRemoveUntil('/', (_) => false);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _actualCode = verificationId;
          });
    }
  }

  Future<void> validateOtpAndLogin(
    BuildContext context,
    String smsCode,
  ) async {
    if (kIsWeb) {
      // web
      UserCredential authResult = await _confirmationResult!.confirm(smsCode);
      if (authResult.user != null) {
        print(authResult.user?.phoneNumber);
        print('Authentication successful');
        onAuthenticationSuccessful(context, authResult.user!);
      }
    } else {
      // mobile
      final AuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _actualCode!,
        smsCode: smsCode,
      );

      await _auth.signInWithCredential(_authCredential).catchError((error) {
        Fluttertoast.showToast(
          msg: 'Wrong code ! Please enter the last code received.',
          backgroundColor: Colors.red,
        );
      }).then((UserCredential authResult) async {
        if (authResult.user != null) {
          print('Authentication successful');
          onAuthenticationSuccessful(context, authResult.user!);
        }
      });
    }
  }

  void onAuthenticationSuccessful(
    BuildContext context,
    User loggedInUser,
  ) {
    Modular.to.popAndPushNamed(
      '/',
    );
  }
}
