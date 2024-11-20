import 'package:flutter/material.dart';
import 'package:swiftycompanion/domain/entities/course.dart';
import 'package:swiftycompanion/domain/entities/skill.dart';

class CourseSkillsList extends StatelessWidget {
  final Course course;

  const CourseSkillsList({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    List<Skill> sortedSkills = List.from(course.skills)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sortedSkills.length,
            itemBuilder: (context, index) {
              final skill = sortedSkills[index];
              final skillLevel = (skill.level / 20).clamp(0.0, 1.0);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          skill.name,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          skill.level.toStringAsFixed(2),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: skillLevel,
                            backgroundColor: Colors.grey[800],
                            color: Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(10),
                            minHeight: 8,
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${(skill.level * 5).toInt()}%',
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
