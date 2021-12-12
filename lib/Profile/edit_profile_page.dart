import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:path/path.dart';
import 'package:riskmanagement/models/user.dart';
import 'package:riskmanagement/utils/user_preferences.dart';
import 'package:riskmanagement/widgets/appbar_widget.dart';
import 'package:riskmanagement/widgets/button_widget.dart';
import 'package:riskmanagement/widgets/profile_widget.dart';
import 'package:riskmanagement/widgets/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          physics: BouncingScrollPhysics(),
          children: [
            ProfileWidget(
              imagePath: user.imagePath,
              isEdit: true,
              onClicked: () async {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Full Name',
              text: user.name,
              onChanged: (name) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'Email',
              text: user.email,
              onChanged: (email) {},
            ),
            const SizedBox(height: 24),
            TextFieldWidget(
              label: 'About',
              text: user.about,
              maxLines: 5,
              onChanged: (about) {},
            ),
            const SizedBox(height: 36),
            ElevatedButton(
              onPressed: () {
                Modular.to.pushNamed('/');
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
          ],
        ),
      );
}
