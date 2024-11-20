import 'package:swiftycompanion/domain/entities/skill.dart';

class Course {
  final int id;
  final String name;
  final String grade;
  final double level;
  final String blackholedAt;
  final List<Skill> skills;

  Course({
    required this.id,
    required this.name,
    required this.grade,
    required this.level,
    required this.blackholedAt,
    required this.skills
  });
}
