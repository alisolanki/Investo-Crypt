import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
  static const route = '/about-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // About Us Title
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "About Us",
                  style: Theme.of(context).textTheme.headline2!.copyWith(
                        color: Colors.deepPurpleAccent,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "This is Risk Management Portfolio website where you can get your custom made Portfolio according to your risk appetite and duration of investment.",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "Our Complex Algorithm helps you choose the best Portfolio with the maximum returns according to your risk and duration of investment.",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: SelectableText(
                  "This was made possible by Mohammed Ali Solanki and Swapnil Jha.",
                  style: Theme.of(context).textTheme.bodyText1!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
