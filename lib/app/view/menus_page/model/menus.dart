import 'package:diuspeeder/app/view/course_enrolment/course_enrolment.dart';
import 'package:diuspeeder/app/view/mark_as_done_page/mark_as_done_page.dart';
import 'package:diuspeeder/app/view/menus_page/model/menu.dart';
import 'package:diuspeeder/app/view/vpl_post_page/vpl_post_page.dart';
import 'package:flutter/Material.dart';

const List<Menu> menus = [
  Menu(
    image: AssetImage('assets/vpl.png'),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.blue, Color.fromARGB(206, 46, 175, 240)],
    ),
    pageOpen: VPLPostPage.pathName,
    isLoginRequired: true,
    icon: Icons.code,
    title: 'VPL posting',
    titleIconColor: Colors.white,
    isComingSoon: false,
  ),
  Menu(
    image: AssetImage('assets/markAsDone.png'),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 23, 185, 120),
        Color.fromARGB(200, 167, 255, 131)
      ],
    ),
    pageOpen: MarkAsDonePage.pathName,
    isLoginRequired: true,
    icon: Icons.done_all,
    title: 'Mark as done',
    titleIconColor: Colors.white,
    isComingSoon: false,
  ),
  Menu(
    image: AssetImage('assets/courseEnrol.png'),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 87, 75, 144),
        Color.fromARGB(206, 252, 133, 174),
      ],
    ),
    pageOpen: CourseEnrolmentPage.pathName,
    isLoginRequired: true,
    icon: Icons.join_full_outlined,
    title: 'Course enrolment',
    titleIconColor: Colors.white,
    isComingSoon: false,
  ),
  Menu(
    image: AssetImage('assets/sgpaBar.png'),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.fromARGB(255, 67, 13, 39),
        Color.fromARGB(200, 201, 78, 78),
      ],
    ),
    pageOpen: VPLPostPage.pathName,
    isLoginRequired: true,
    icon: Icons.school_rounded,
    title: 'CGPA checker',
    titleIconColor: Colors.white,
    isComingSoon: true,
  ),
];
