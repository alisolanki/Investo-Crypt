import 'dart:html';
import 'dart:io';
import 'dart:js_util';

import 'package:decimal/decimal.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:riskmanagement/Login/register_page.dart';
import 'package:riskmanagement/Profile/profile_page.dart';
import 'package:riskmanagement/provider/data_provider.dart';
import 'package:riskmanagement/provider/input_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/json_rpc.dart';
import 'package:web3dart/web3dart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var riskValue = 1.0;
  var durationValue = 1.0;
  var client;
  bool hasLoggedIn = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // client = Web3Client(
    //   'https://data-seed-prebsc-1-s1.binance.org:8545/',
    // );
  }

  void _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    hasLoggedIn = FirebaseAuth.instance.currentUser != null;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(
                'Register',
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                visualDensity: VisualDensity(
                  horizontal: 0.8,
                  vertical: 0.5,
                ),
              ),
              onPressed: () {
                print('register');
                Modular.to.pushNamed(RegisterPage.route);
              },
            ),
          ),
          hasLoggedIn
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(
                      'Profile',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.amber[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      visualDensity: VisualDensity(
                        horizontal: 0.8,
                        vertical: 0.5,
                      ),
                    ),
                    onPressed: () {
                      print('profile');
                      Modular.to.pushNamed(ProfilePage.route);
                    },
                  ),
                )
              : Container(),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 64.0,
                horizontal: 16.0,
              ),
              child: SelectableText(
                'Risk Management',
                style: Theme.of(context).textTheme.headline2?.copyWith(
                      color: Colors.amber,
                    ),
              ),
            ),
            Column(
              children: [
                SelectableText(
                  'Risk',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Container(
                  width: 300,
                  child: Slider(
                    value: riskValue,
                    min: 1.0,
                    max: 99,
                    activeColor: riskValue < 25
                        ? Colors.deepPurple[200]
                        : riskValue < 50
                            ? Colors.deepPurple[400]
                            : riskValue < 75
                                ? Colors.deepPurple
                                : Colors.amber,
                    onChanged: (_v) async {
                      setState(() {
                        riskValue = _v;
                        Provider.of<InputProvider>(context, listen: false)
                            .riskValue = riskValue;
                      });
                      // if (_v == 99) {
                      //   await Fluttertoast.showToast(
                      //     msg: "Jordan Belfort is that you?",
                      //     webBgColor:
                      //         "linear-gradient(to right, #FF0000, #FF0000)",
                      //     webShowClose: true,
                      //     fontSize: 120,
                      //     timeInSecForIosWeb: 5,
                      //     gravity: ToastGravity.CENTER,
                      //   );
                      //   await Fluttertoast.cancel();
                      // }
                    },
                  ),
                ),
                SelectableText(
                  "${riskValue.round()}%${riskValue == 99 ? ", Jordan Belfort is that you?" : ""}",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                children: [
                  SelectableText(
                    'Duration',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    width: 300,
                    child: Slider(
                      value: durationValue,
                      min: 1.0,
                      max: 100,
                      activeColor: durationValue < 6
                          ? Colors.deepPurple[200]
                          : durationValue < 12
                              ? Colors.deepPurple[400]
                              : durationValue < 24
                                  ? Colors.deepPurple
                                  : Colors.amber,
                      onChanged: (_v) {
                        setState(() {
                          durationValue = _v;
                          Provider.of<InputProvider>(context, listen: false)
                              .durationValue = durationValue;
                        });
                      },
                    ),
                  ),
                  SelectableText(
                    '${durationValue.round()} months',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Modular.to.pushNamed('/result');
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                visualDensity: VisualDensity(
                  horizontal: 0.8,
                  vertical: 0.5,
                ),
              ),
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: 14,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: TextButton(
                child: Text(
                  "contact us",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
                onPressed: () => _launchURL('https://alisolanki.com'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
