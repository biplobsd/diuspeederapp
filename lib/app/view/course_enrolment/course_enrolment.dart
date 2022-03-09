import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:flutter/material.dart';

class CourseEnrolmentPage extends StatelessWidget {
  const CourseEnrolmentPage({Key? key}) : super(key: key);

  static const String pathName = '/course_enrolment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppbar(
        title: const Text('Course Enrolment'),
      ),
      body: const Center(
        child: Text('Course enrollment'),
      ),
    );
  }
}
