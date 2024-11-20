import 'package:swiftycompanion/domain/entities/project.dart';

class ProjectModel extends Project {
  ProjectModel({
    required super.id,
    required super.name,
    required super.occurrence,
    required super.status,
    required super.marked,
    required super.markedAt,
    required super.finalMark,
    required super.validated,
    required super.coursesId,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    List<int> coursesId = List<int>.from(json['cursus_ids'] ?? []);
    return ProjectModel(
      id: json['project']['id'] ?? 0,
      name: json['project']['name'] ?? 'null',
      occurrence: json['occurrence'] ?? 0,
      status: json['status'] ?? 'null',
      marked: json['marked'] ?? false,
      markedAt: json['marked_at'] ?? 'not closed',
      finalMark: json['final_mark'] ?? 0,
      validated: json['validated?'] ?? false,
      coursesId: coursesId,
    );
  }
}
