import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import './authentication.dart';

class RegisterPage extends StatefulWidget {
  static const String route = '/register';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _showOTP = false, _loading = false, _init = true;
  String _phoneNumber = '', _companyName = '', _name = '';
  String _city = '', otpCode = '';

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
                  onPressed: () => Modular.to.popAndPushNamed(
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
      if (_showOTP) {
        await authenticationProvider.validateOtpAndLogin(
          context,
          otpCode,
        );
        _phoneNumber = _phoneNumber.trim();
        if (_phoneNumber.length == 10) {
          _phoneNumber = '+91' + _phoneNumber;
        }
        final _uid = FirebaseAuth.instance.currentUser!.uid;
        return await FirebaseFirestore.instance.doc('users/$_uid').set({
          'uid': _uid,
          'name': _name,
          'companyName': _companyName,
          'phoneNumber': _phoneNumber,
          'city': _city,
        });
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
              // Register Title
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "Register",
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.deepPurpleAccent,
                      ),
                ),
              ),
              // name
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  onSaved: (n) {
                    _name = n ?? "0";
                  },
                ),
              ),
              // company name
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Company Name',
                    prefixIcon: Icon(
                      Icons.work,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                  onSaved: (cn) {
                    _companyName = cn ?? "0";
                  },
                ),
              ),
              // company name
              Container(
                width: 300,
                padding: const EdgeInsets.only(
                  bottom: 8.0,
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'City',
                    prefixIcon: Icon(
                      Icons.location_city,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  onSaved: (c) {
                    _city = c ?? "0";
                  },
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
                    'Already registered? Login here',
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
                  onPressed: () => Modular.to.pushNamed('/login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
