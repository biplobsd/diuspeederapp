import 'package:diuspeeder/app/appbar_custom.dart';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class MarkAsDonePage extends StatelessWidget {
  const MarkAsDonePage({Key? key}) : super(key: key);
  static const String pathName = '/markAsDonePage';

  @override
  Widget build(BuildContext context) {
    return const MarkAsDoneScreen();
  }
}

class MarkAsDoneScreen extends StatelessWidget {
  const MarkAsDoneScreen({
    Key? key,
  }) : super(key: key);

  Future<void> dialogHelpInfo({
    required BuildContext context,
    required String title,
    required String helpImgPath,
  }) async {
    await showDialog<dynamic>(
      context: context,
      builder: (cnt) => AlertDialog(
        title: Text(title),
        content: InteractiveViewer(
          panEnabled: false,
          minScale: 0.5,
          maxScale: 1,
          child: Image.asset(
            helpImgPath,
            width: 350,
            height: 350,
            fit: BoxFit.cover,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(cnt).pop();
            },
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('Mark as done'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton(
                icon: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    dialogHelpInfo(
                      context: context,
                      title: 'Select Semeter',
                      helpImgPath: 'assets/vplcopypageid.gif',
                    );
                  },
                ),
                hint: const Text('Spring 2022'),
                isExpanded: true,
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (v) => print,
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButton(
                icon: IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    dialogHelpInfo(
                      context: context,
                      title: 'Select Course',
                      helpImgPath: 'assets/vplcopypageid.gif',
                    );
                  },
                ),
                hint: const Text('Course title'),
                isExpanded: true,
                items: <String>['One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (v) => print,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: GFProgressBar(
                  lineHeight: 20,
                  alignment: MainAxisAlignment.spaceBetween,
                  percentage: 0.6,
                  backgroundColor: Colors.black26,
                  progressBarColor: GFColors.INFO,
                  child: const Text(
                    '80%',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 13, color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                height: MediaQuery.of(context).size.height * .55,
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                            Colors.greenAccent,
                          ),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle),
                        label: const Text(
                          '1234 | W-2 Lab Practice (prob-1)Virtual programming lab',
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.redAccent),
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.cancel),
                        label: const Text(
                          '1234 | W-2 Lab Practice (prob-2) PC-BVirtual programming lab',
                          maxLines: 1,
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {},
          child: const Text('Mark as Done'),
        ),
      ),
    );
  }
}
