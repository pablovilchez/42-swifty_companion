import 'package:swiftycompanion/domain/entities/course.dart';
import 'package:swiftycompanion/domain/entities/project.dart';

class User {
  final String login;
  final String name;
  final String photo;
  final String email;
  final List<Course> courses;
  final List<Project> projects;
  final int evalPoints;
  final int wallet;

  User({
    required this.login,
    required this.name,
    required this.photo,
    required this.email,
    required this.courses,
    required this.projects,
    required this.evalPoints,
    required this.wallet,
  });
}
