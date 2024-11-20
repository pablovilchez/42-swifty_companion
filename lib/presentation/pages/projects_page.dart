import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:swiftycompanion/domain/entities/project.dart';
import 'package:swiftycompanion/domain/entities/course.dart';
import 'package:swiftycompanion/domain/entities/user.dart';
import 'package:swiftycompanion/application/providers/auth_provider.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage(
      {super.key, required this.user, required this.selectedCourse});

  final User user;
  final Course selectedCourse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.login}\n${selectedCourse.name}',
            style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/green_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: user.projects.length,
          itemBuilder: (context, index) {
            final project = user.projects[index];
            if (!project.coursesId.contains(selectedCourse.id)) {
              return const SizedBox();
            }
            return _ProjectCard(
                userLogin: user.login, project: project, courses: user.courses);
          },
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.userLogin,
    required this.project,
    required this.courses,
  });

  final String userLogin;
  final Project project;
  final List<Course> courses;

  @override
  Widget build(BuildContext context) {
    final int courseId = project.coursesId.first;
    courses.firstWhere((course) => course.id == courseId).name;
    final closedAt = project.markedAt == 'not closed'
        ? 'not closed'
        : project.markedAt.substring(0, 10);
    final occurrence =
        project.marked ? project.occurrence + 1 : project.occurrence;
    String projectState = '';
    Color projectStateColor = Colors.white;

    if (project.marked && project.validated) {
      projectState = 'Finished';
      projectStateColor = Colors.green;
    } else if (project.marked && !project.validated) {
      projectState = 'Failed';
      projectStateColor = Colors.red;
    } else {
      projectState = 'In progress';
      projectStateColor = Colors.yellow;
    }

    return Card(
      color: Colors.black.withOpacity(0.5),
      child: ListTile(
          title: Text(project.name,
              style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 80,
                  child: _FormattedSection(
                      title: 'Attempts:',
                      value: '     ${occurrence.toString()}')),
              SizedBox(
                width: 100,
                child: _FormattedSection(
                    title: 'State:',
                    value: projectState,
                    color: projectStateColor),
              ),
              SizedBox(
                  width: 90,
                  child:
                      _FormattedSection(title: 'Closed at:', value: closedAt)),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Stack(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        project.finalMark.toString(),
                        style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    value: project.finalMark / 100,
                    valueColor: project.validated
                        ? const AlwaysStoppedAnimation(Colors.green)
                        : const AlwaysStoppedAnimation(Colors.red),
                    backgroundColor: Colors.white.withOpacity(0.07),

                    //child: Text(project.finalMark.toString()),
                  ),
                ),
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    value: (project.finalMark - 100) / 100,
                    valueColor:
                        const AlwaysStoppedAnimation(Colors.lightGreenAccent),
                    backgroundColor: Colors.white.withOpacity(0.07),
                  ),
                )
              ],
            ),
          ),
          onTap: () async {
            final authProvider =
                Provider.of<AuthProvider>(context, listen: false);
            final attempts = await authProvider.getProjectAttempts(userLogin, project.id);
            // reverse the list of attempts to show the most recent first
            final reversedAttempts = attempts.attempts.reversed.toList();
            if(context.mounted) {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                builder: (context) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Project: ${project.name}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Attempts:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          for (final attempt in reversedAttempts)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 50),
                                    SizedBox(
                                      width: 40,
                                      child: _FormattedSection(
                                        title: 'Mark:',
                                        value: attempt.finalMark == null
                                            ? 'n/d'
                                            : attempt.finalMark.toString(),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 100,
                                      child: _FormattedSection(
                                        title: 'State:',
                                        value: () {
                                          if (attempt.validated == null) {
                                            return 'In progress';
                                          } else if (attempt.validated == true) {
                                            return 'Finished';
                                          } else {
                                            return 'Failed';
                                          }
                                        }(),
                                        color: () {
                                          if (attempt.validated == null) {
                                            return Colors.yellow;
                                          } else if (attempt.validated == true) {
                                            return Colors.green;
                                          } else {
                                            return Colors.red;
                                          }
                                        }(),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    SizedBox(
                                      width: 120,
                                      child: _FormattedSection(
                                        title: 'Closed at:',
                                        value: attempt.validated == null
                                            ? 'not closed'
                                            : attempt.updatedAt.substring(0, 10),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}

class _FormattedSection extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _FormattedSection({
    required this.title,
    required this.value,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            )),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            //fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
