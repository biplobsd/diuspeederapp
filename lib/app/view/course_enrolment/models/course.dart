class Course {
  Course({
    required this.title,
    required this.enrollmentKey,
    required this.id,
    required this.state, // 2 is checking; 1 is enrolled; 0 is unenroll
  });
  int id;
  int state;
  String title;
  String enrollmentKey;
}
