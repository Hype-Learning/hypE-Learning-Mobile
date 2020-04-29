import 'package:flutter/material.dart';
import 'package:hype_learning/providers/courses.dart';
import 'package:hype_learning/screens/add_course_screen.dart';
import 'package:hype_learning/screens/edit_course_screen.dart';
import 'package:hype_learning/screens/user_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/custom_route.dart';
import 'providers/auth.dart';
import 'screens/course_detail_screen.dart';
import 'screens/courses_overview_screen.dart';
import 'screens/signIn_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/signUp_screen.dart';

SharedPreferences sharedPrefs;

void main () async {
  WidgetsFlutterBinding.ensureInitialized(); 
  sharedPrefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Courses>(
            create: (ctx) => Courses(),
            update: (context, auth, courses) => courses.update(
              auth.token,
              auth.userId,
              courses == null ? [] : courses.courses,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'HypE-Learning',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                accentColor: Colors.greenAccent,
                fontFamily: 'Montserrat',
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  },
                ),
              ),
              home: auth.isAuth
                  ? CoursesOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : SignInScreen(),
                    ),
              routes: {
                SignInScreen.routeName: (ctx) => SignInScreen(),
                SignUpScreen.routeName: (ctx) => SignUpScreen(),
                CourseDetailScreen.routeName: (ctx) => CourseDetailScreen(),
                CoursesOverviewScreen.routeName: (ctx) =>
                    CoursesOverviewScreen(),
                AddCourseScreen.routeName: (ctx) => AddCourseScreen(),
                EditCourseScreen.routeName: (ctx) => EditCourseScreen(),
                UserProfileScreen.routeName: (ctx) => UserProfileScreen(),
              }),
        ));
  }
}
