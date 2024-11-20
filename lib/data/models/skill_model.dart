import 'package:swiftycompanion/domain/entities/skill.dart';

class SkillModel extends Skill {
  SkillModel({
    required super.name,
    required super.level,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      name: json['name'] ?? 'null',
      level: json['level'] ?? 0,
    );
  }
}
