import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import './authentication.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showOTP = false, _loading = false, _init = true;
  String _phoneNumber = '', otpCode = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_init) {
      if (FirebaseAuth.instance.currentUser != null) {
        // already logged in
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title:
                  SelectableText('You are logged in, go to Home page instead!'),
              actions: [
                ElevatedButton(
                  child: Text('Home Page'),
                  onPressed: () => Navigator.popAndPushNamed(
                    context,
                    '/',
                  ),
                ),
              ],
            ),
          );
        });
      }
    }
    _init = false;
  }

  Future<void> submit() async {
    setState(() {
      _loading = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final authenticationProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      _phoneNumber = _phoneNumber.trim();
      if (_phoneNumber.length == 10) {
        _phoneNumber = '+91' + _phoneNumber;
      }
      // check if user hasn't registered
      final checkUser = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: _phoneNumber)
          .get();
      if (checkUser == null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: SelectableText(
                'You have not registered, go to Register page instead!'),
            actions: [
              ElevatedButton(
                child: Text('Register Page'),
                onPressed: () => Modular.to.pushNamedAndRemoveUntil(
                  '/register',
                  (route) => false,
                ),
              ),
            ],
          ),
        );
        return;
      }
      if (_showOTP) {
        await authenticationProvider.validateOtpAndLogin(
          context,
          otpCode,
        );
      } else {
        await authenticationProvider
            .signInWithPhoneNumber(
          context,
          _phoneNumber,
        )
            .then((_) {
          setState(() {
            _showOTP = true;
          });
        }, onError: (_) {
          Fluttertoast.showToast(
            msg: 'Error Occured',
            backgroundColor: Colors.red,
            webBgColor: "linear-gradient(to right, #f44336, #f44336)",
            gravity: ToastGravity.TOP,
          );
          setState(() {
            _showOTP = false;
          });
        });
      }
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Login Title
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "Login",
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.deepPurpleAccent,
                      ),
                ),
              ),
              // phone number
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: '+91',
                    prefixIcon: Icon(
                      Icons.phone,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  onSaved: (pn) {
                    _phoneNumber = pn ?? "0";
                  },
                ),
              ),
              // otp
              AnimatedContainer(
                duration: Duration(seconds: 2),
                curve: Curves.bounceOut,
                width: _showOTP ? 200 : 0,
                child: _showOTP
                    ? TextFormField(
                        decoration: InputDecoration(
                          hintText: 'OTP',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        onSaved: (_otp) {
                          if (_showOTP) {
                            otpCode = _otp ?? "0";
                          }
                        },
                      )
                    : SizedBox(),
              ),
              //submit
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  child: Text(
                    _loading ? 'Loading' : 'Submit',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  onPressed: _loading ? null : () => submit(),
                ),
              ),
              //register
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextButton(
                  child: Text(
                    'Don\'t have an account? Register here',
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.deepPurpleAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pushNamed('/register'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
