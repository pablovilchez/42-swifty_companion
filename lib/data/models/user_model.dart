import 'package:swiftycompanion/data/models/project_model.dart';
import 'package:swiftycompanion/data/models/course_model.dart';
import 'package:swiftycompanion/domain/entities/user.dart';


class UserModel extends User {
  UserModel({
    required super.login,
    required super.name,
    required super.photo,
    required super.email,
    required super.courses,
    required super.projects,
    required super.evalPoints,
    required super.wallet,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      login: json['login'] ?? '',
      name: json['displayname'] ?? '',
      photo: json['image']['versions']['small'] ?? '',
      email: json['email'] ?? '',
      courses: json['cursus_users']
          .map<CourseModel>((course) => CourseModel.fromJson(course))
          .toList(),
      projects: json['projects_users']
          .map<ProjectModel>((project) => ProjectModel.fromJson(project))
          .toList(),
      evalPoints: json['correction_point'] ?? 0,
      wallet: json['wallet'] ?? 0,
    );
  }
}
