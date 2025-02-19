import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/task_list_page.dart';

class LogInOption extends StatelessWidget {
  final String method;
  const LogInOption({super.key, required this.method});

  Color _getBackgroundColor() {
    switch (method.toLowerCase()) {
      case 'google':
        return Colors.red;
      case 'facebook':
        return Colors.blue;
      case 'apple':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (method.toLowerCase()) {
      case 'google':
        return FontAwesomeIcons.google;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'apple':
        return FontAwesomeIcons.apple;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: _getBackgroundColor(),
      child: IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const TaskListScreen()));
        },
        icon: Icon(
          _getIcon(),
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
