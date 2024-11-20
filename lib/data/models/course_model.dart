import 'package:swiftycompanion/data/models/skill_model.dart';
import 'package:swiftycompanion/domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.name,
    required super.grade,
    required super.level,
    required super.blackholedAt,
    required super.skills});

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['cursus']['id'] ?? 0,
      name: json['cursus']['name'] ?? 'null',
      grade: json['grade'] ?? 'undefined',
      level: json['level'].toDouble(),
      blackholedAt: json['blackhole'] ?? 'null',
      skills: json['skills']
          .map<SkillModel>((skill) => SkillModel.fromJson(skill))
          .toList(),
    );
  }
}
