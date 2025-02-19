import 'package:flutter/material.dart';

class RightLogo extends StatelessWidget {
  const RightLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/right_logo.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
