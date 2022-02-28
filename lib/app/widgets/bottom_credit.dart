import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhoCreated extends StatelessWidget {
  const WhoCreated({Key? key}) : super(key: key);

  Future<void> _launchURL() async {
    const devPageUrl =
        'https://play.google.com/store/apps/dev?id=7013622463085625240';
    if (!await launch(
      devPageUrl,
    )) throw Exception('Could not launch $devPageUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Simplify your life',
      child: TextButton(
        onPressed: _launchURL,
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Created by',
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(
                width: 5,
              ),
              CircleAvatar(
                radius: 10,
                child: Image.asset('assets/speedOutLogo.png'),
              ),
              const SizedBox(
                width: 1,
              ),
              Text(
                ' SpeedOut',
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
