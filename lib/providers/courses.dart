import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hype_learning/config/constants.dart';
import 'package:hype_learning/providers/profile.dart';
import '../config/constants.dart';
import '../models/http_exception.dart';
import './course.dart';

class Courses with ChangeNotifier {
  List<Course> _courses = [];
  List<Profile> _participants = [];
   List<Profile> _candidates =[];
  String authToken;
  int userId;

  Courses();

  List<Course> get courses {
    return [..._courses];
  }

    List<Profile> get participants {
    return [..._participants];
  }
  
    List<Profile> get candidates {
    return [..._candidates];
  }

  Courses update(authToken, userId, _courses) {
    this.authToken = authToken;
    this.userId = userId;
    this._courses = _courses;
    return this;
  }

  Course findById(int id) {
    return _courses.firstWhere((course) => course.id == id);
  }

  Future<void> fetchAndSetStudentCourses() async {
    _courses = new List<Course>();
    var url = Constants.API_URL + 'users/courses';
 try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body).toList(); //check if unathorized
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedCourses = [];
      extractedData.forEach((courseData) {
        loadedCourses.add(Course(
          id: courseData['id'],
          title: courseData['title'],
          description: courseData['description'],
          announcement: courseData['announcement'],
        ));
      });
      _courses = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetCourses() async {
    var url = Constants.API_URL + 'courses';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body).toList();
      if (extractedData == null) {
        return;
      }
      final List<Course> loadedCourses = [];
      extractedData.forEach((courseData) {
        loadedCourses.add(Course(
          id: courseData['id'],
          title: courseData['title'],
          description: courseData['description'],
          announcement: courseData['announcement'],
        ));
      });
      _courses = loadedCourses;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addCourse(Course course) async {
    final url = Constants.API_URL + 'courses';
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
        body: json.encode({
          'title': course.title,
          'description': course.description,
          'announcement': course.announcement,
        }),
      );
      final newCourse = Course(
        title: course.title,
        description: course.description,
        announcement: course.announcement,
        id: json.decode(response.body)['id'],
      );
      _courses.add(newCourse);
      // _courses.insert(0, newCourse); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateCourse(int id, Course newCourse) async {
    final courseIndex = _courses.indexWhere((course) => course.id == id);
    if (courseIndex >= 0) {
       final url = Constants.API_URL + 'courses/$id';
      await http.put(url,headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
          body: json.encode({
            'title': newCourse.title,
            'description': newCourse.description,
            'announcement': newCourse.announcement,
          }));
      _courses[courseIndex] = newCourse;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteCourse(int id) async {
    final url = Constants.API_URL + 'courses/$id';
    final existingCourseIndex =
        _courses.indexWhere((course) => course.id == id);
    var existingCourse = _courses[existingCourseIndex];
    _courses.removeAt(existingCourseIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ' + this.authToken,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode >= 400) {
      _courses.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Nie można usunąć kursu.');
    }
    existingCourse = null;
  }


 Future<void> fetchAndSetParticipants(int id) async {
    var url = Constants.API_URL + 'courses/$id';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body)['participants'].toList();
      if (extractedData == null) {
        return;
      }
      final List<Profile> loadedParticipants = [];
      extractedData.forEach((profileData) {
        loadedParticipants.add(Profile(
          id: profileData['id'],
          firstName: profileData['firstName'],
          lastName: profileData['lastName'],

        ));
      });
     _participants = loadedParticipants;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }



 Future<void> deleteParticipant(int id, int participantId) async {
    final url = Constants.API_URL + 'courses/$id/students/$participantId';
    final existingCourseIndex =
        _courses.indexWhere((course) => course.id == id);
    var existingCourse = _courses[existingCourseIndex];
    _courses.removeAt(existingCourseIndex);
    notifyListeners();
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ' + this.authToken,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode >= 400) {
      _courses.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Nie można usunąć uczestnika.');
    }
    existingCourse = null;
  }




 Future<void> fetchAndSetCandidates(int id) async {
    var url = Constants.API_URL + 'courses/$id/candidates';
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ' + this.authToken,
          'Content-Type': 'application/json'
        },
      );
      final extractedData = json.decode(response.body).toList();
      if (extractedData == null) {
        return;
      }
      final List<Profile> loadedCandidates = [];
      extractedData.forEach((profileData) {
        loadedCandidates.add(Profile(
          id: profileData['id'],
          firstName: profileData['firstName'],
          lastName: profileData['lastName'],

        ));
      });
     _candidates = loadedCandidates;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }


  Future<void> addCandidate(int id, int participantId) async {
    final url = Constants.API_URL + 'courses/$id/students/$participantId';
    final existingCourseIndex =
        _courses.indexWhere((course) => course.id == id);
    var existingCourse = _courses[existingCourseIndex];
    _courses.removeAt(existingCourseIndex);
    notifyListeners();
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer ' + this.authToken,
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode >= 400) {
      _courses.insert(existingCourseIndex, existingCourse);
      notifyListeners();
      throw HttpException('Nie można usunąć uczestnika.');
    }
    existingCourse = null;
  }






}
