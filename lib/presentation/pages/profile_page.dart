import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:swiftycompanion/presentation/pages/projects_page.dart';
import 'package:swiftycompanion/data/models/user_model.dart';
import 'package:swiftycompanion/application/providers/user_provider.dart';
import 'package:swiftycompanion/domain/entities/course.dart';
import 'package:swiftycompanion/presentation/widgets/course_skills_list.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: userProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProvider.errorMessage.isNotEmpty
              ? Center(child: Text(userProvider.errorMessage))
              : _buildUserContent(userProvider.user, userProvider, context),
    );
  }

  Widget _buildUserContent(
      UserModel? user, UserProvider userProvider, BuildContext context) {
    if (user == null) return const Center(child: Text('User not found'));
    final courses = user.courses.map((course) => course.name).toList();
    final selectedCourse = user.courses
        .firstWhere((course) => course.name == userProvider.selectedCourse);

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/green_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            _UserInfoHeader(user: user),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Course:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                _CursusDropDown(courses: courses, userProvider: userProvider),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Grade:", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Text(
                  selectedCourse.grade,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _UserValuesCard(user: user, course: selectedCourse),
            Card(
              color: Colors.black.withOpacity(0.5),
              elevation: 3,
              child: CourseSkillsList(course: selectedCourse),
            ),
            Card(
              color: Colors.black.withOpacity(0.5),
              child: ListTile(
                textColor: Colors.white,
                title: const Text("See projects of selected course"),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProjectsPage(
                        user: user,
                        selectedCourse: selectedCourse,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserValuesCard extends StatelessWidget {
  const _UserValuesCard({
    required this.user,
    required this.course,
  });

  final UserModel user;
  final Course course;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.5),
      elevation: 3,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _UserValuesBox(
                title: 'Level',
                value: course.level.toString(),
                color: Colors.cyan,
              ),
              _UserValuesBox(
                title: 'Ev. Points',
                value: user.evalPoints.toString(),
                color: Colors.red,
              ),
              _UserValuesBox(
                title: 'Wallet',
                value: user.wallet.toString(),
                symbol: '₳',
                color: Colors.teal.shade700,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 15, bottom: 8),
            child: SizedBox(
              height: 5,
              width: 330,
              child: LinearProgressIndicator(
                value: (course.level.toDouble() * 100) % 100 / 100,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation(Colors.cyan),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _UserValuesBox extends StatelessWidget {
  final String title;
  final String value;
  final String symbol;
  final Color color;

  const _UserValuesBox({
    required this.title,
    required this.value,
    this.symbol = '',
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: color)),
          Text('$value $symbol', style: TextStyle(fontSize: 20, color: color)),
        ],
      ),
    );
  }
}

class _CursusDropDown extends StatelessWidget {
  final dynamic userProvider;

  const _CursusDropDown({
    required this.courses,
    required this.userProvider,
  });

  final List<String> courses;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      alignment: Alignment.center,

      value: userProvider.selectedCourse,
      items: courses.map((course) {
        return DropdownMenuItem(
          value: course,
          child: Text(course, style: const TextStyle(fontSize: 14)),
        );
      }).toList(),
      onChanged: (newCourse) {
        if (newCourse != null) {
          userProvider.setSelectedCourse(newCourse);
        }
      },
    );
  }
}

class _UserInfoHeader extends StatelessWidget {
  final UserModel user;

  const _UserInfoHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          child: ClipOval(
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/loading.png',
              image: user.photo,
              fit: BoxFit.cover,
              width: 77,
              height: 77,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.login, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text(user.name, style: const TextStyle(fontSize: 12)),
            Text(user.email, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
