class Project {
  final int id;
  final String name;
  final int occurrence;
  final String status;
  final bool marked;
  final String markedAt;
  final int finalMark;
  final bool validated;
  final List<int> coursesId;

  Project({
    required this.id,
    required this.name,
    required this.occurrence,
    required this.status,
    required this.marked,
    required this.markedAt,
    required this.finalMark,
    required this.validated,
    required this.coursesId
  });
}
