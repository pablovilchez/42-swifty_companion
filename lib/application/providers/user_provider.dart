import 'package:flutter/material.dart';

import 'package:swiftycompanion/data/models/user_model.dart';
import 'package:swiftycompanion/domain/entities/course.dart';
import 'package:swiftycompanion/data/models/course_model.dart';
import 'package:swiftycompanion/application/providers/auth_provider.dart';


class UserProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = true;
  bool _isSearching = false;
  String _errorMessage = '';
  String _selectedCourse = '';

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get errorMessage => _errorMessage;
  String get selectedCourse => _selectedCourse;

  Future<void> loadUser(String userLogin, AuthProvider authProvider) async {
    _isLoading = true;
    _isSearching = true;
    notifyListeners();

    try {
      _user = await authProvider.getUserData(userLogin);
      _errorMessage = '';
      _isLoading = false;
      _setInitialSelectedCourse();
    } catch (error) {
      _errorMessage = 'User not found';
    } finally {
      _isSearching = false;
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setInitialSelectedCourse() {
    if (_user != null) {
      final Course course = (_user!.courses).firstWhere(
        (course) => course.name == '42cursus',
        orElse: () => _user!.courses.first as CourseModel,
      );
      _selectedCourse = course.name;
    }
  }

  void setSelectedCourse(String course) {
    _selectedCourse = course;
    notifyListeners();
  }
}
