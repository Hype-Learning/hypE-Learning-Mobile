import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/topic.dart';
import '../providers/topics.dart';
import 'courses_overview_screen.dart';
import 'topics_overview_screen.dart';

class EditTopicScreen extends StatefulWidget {
  static const routeName = '/edit-topic';

  @override
  _EditTopicScreenState createState() => _EditTopicScreenState();
}

class _EditTopicScreenState extends State<EditTopicScreen> {
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _announcementFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedTopic = Topic(
    id: null,
    title: '',
    description: '',
  );
  var _initValues = {
    'title': '',
    'description': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final dynamic args = ModalRoute.of(context).settings.arguments;
      if (args.first != null) {
        _editedTopic =
            Provider.of<Topics>(context, listen: false).findById(args.first);
        _initValues = {
          'title': _editedTopic.title,
          'description': _editedTopic.description,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _announcementFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Topics>(context, listen: false)
          .updateTopic(_editedTopic.id, _editedTopic);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occurred!'),
          content: Text('Something went wrong.'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pushNamed(TopicsOverviewScreen.routeName);
              },
            )
          ],
        ),
      );
    }
    // finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }

    setState(() {
      _isLoading = false;
    });
      Navigator.of(context).popAndPushNamed(
        CoursesOverviewScreen.routeName); // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
      // final EditTopicArguments args = ModalRoute.of(context).settings.arguments;
      // int TopicId = args.id;
      // Topic Topic = args.Topic;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytuj temat'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Tytuł'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedTopic = Topic(
                          title: value,
                          description: _editedTopic.description,
                          id: _editedTopic.id,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Opis'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_announcementFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'To pole jest wymagane';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedTopic = Topic(
                          title: _editedTopic.title,
                          description: value,
                          id: _editedTopic.id,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
