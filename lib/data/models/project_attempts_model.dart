import 'dart:core';
import 'package:swiftycompanion/domain/entities/project_attempt.dart';

class ProjectAttemptsModel {
  final String projectName;
  final List<ProjectAttempt> attempts;

  ProjectAttemptsModel({
    required this.projectName,
    required this.attempts,
  });

  factory ProjectAttemptsModel.fromJson(List<dynamic> json) {
    final projectName = json[0]['project']['name'] ?? 'Unknown project';

    final attempts = (json[0]['teams'] as List).map((attempt) {
      return ProjectAttempt(
        validated: attempt['validated?'] as bool?,
        finalMark: attempt['final_mark'] as int?,
        updatedAt: attempt['updated_at'].toString().substring(0, 10),
      );
    }).toList();

    return ProjectAttemptsModel(
      projectName: projectName,
      attempts: attempts,
    );
  }
}
