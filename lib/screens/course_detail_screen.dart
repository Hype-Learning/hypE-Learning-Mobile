import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';

class CourseDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;

  // ProductDetailScreen(this.title, this.price);
  static const routeName = '/course-detail';

  @override
  Widget build(BuildContext context) {
    final courseId =
        ModalRoute.of(context).settings.arguments as int; // is the id!
    final loadedCourse = Provider.of<Courses>(
      context,
      listen: false,
    ).findById(courseId);

    final topContentText = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 90.0,
          child: new Divider(color: Colors.green),
        ),
        SizedBox(height: 20.0),
        Text(
          loadedCourse.title,
          style: TextStyle(color: Colors.white, fontSize: 45.0),
        ),
        SizedBox(height: 20.0),
        Text(
          loadedCourse.description,
          style: TextStyle(fontSize: 14.0, color: Colors.white),
        )
      ],
    );

    final topContent = Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.blue[800]),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    //    final  bottomContentText = Padding(
    // padding: EdgeInsets.all(8.0),
    // child: Column(children: [
    //   Center(
    //     child: Text('Opis',
    //     style: TextStyle(fontSize: 24.0),),
    //   ),
    //       SizedBox(height: 20),
    //   Text(
    //     loadedCourse.description,
    //     style: TextStyle(fontSize: 14.0),
    //   )
    // ]));

    final bottomAnnouncementText = Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(children: [
          Center(
            child: Text(
              'Ogłoszenia',
              style: TextStyle(fontSize: 24.0),
            ),
          ),
          SizedBox(height: 20),
          Text(
            loadedCourse.announcement,
            style: TextStyle(fontSize: 14.0),
          )
        ]));

    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          onPressed: () => {},
          color: Colors.blue[800],
          child: Text("Topics",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        ));

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(40.0),
      child: Center(
        child: Column(
          children: <Widget>[bottomAnnouncementText, readButton],
        ),
      ),
    );

    return Scaffold(
        body: ListView(
      children: <Widget>[topContent, bottomContent],
    ));
  }
}