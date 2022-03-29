import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:diuspeeder/app/view/course_enrolment/models/course.dart';
import 'package:flutter/material.dart';

class CourseEnrolmentPage extends StatelessWidget {
  const CourseEnrolmentPage({Key? key}) : super(key: key);

  static const String pathName = '/course_enrolment';

  @override
  Widget build(BuildContext context) {
    return CourseEnrolmentScreen();
  }
}

class CourseEnrolmentScreen extends StatefulWidget {
  CourseEnrolmentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CourseEnrolmentScreen> createState() => _CourseEnrolmentScreenState();
}

class _CourseEnrolmentScreenState extends State<CourseEnrolmentScreen> {
  List<Course> listCourses = [
    Course(
      title: 'Algorithms[PC-A+PC-B][Spring-22]',
      id: 14226,
      enrollmentKey: 'CSE1234',
    )
  ];

  TextEditingController urlController = TextEditingController();

  TextEditingController enrollkeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('Course Enrolment'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...listCourses.map(
              (e) => ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.tiktok),
                  onPressed: () {},
                ),
                title: Text(e.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      listCourses.removeWhere((element) => element.id == e.id);
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ElevatedButton(
                onPressed: () {
                  showDialog<dynamic>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Add your course'),
                      content: Container(
                        height: 150,
                        child: Column(
                          children: [
                            TextField(
                              controller: urlController,
                              decoration: const InputDecoration(
                                label: Text('URL'),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: enrollkeyController,
                              decoration: const InputDecoration(
                                label: Text('Enroll key'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Add'),
                          onPressed: () {
                            setState(() {
                              listCourses.add(
                                Course(
                                  id: 111,
                                  title: urlController.text,
                                  enrollmentKey: enrollkeyController.text,
                                ),
                              );
                            });

                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black12),
                ),
                child: const Icon(Icons.add),
              ),
            )
          ],
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
          child: const Text('Enroll'),
        ),
      ),
    );
  }
}
