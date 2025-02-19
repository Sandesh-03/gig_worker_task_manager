import 'package:flutter/material.dart';
import 'package:gig_worker_task_manager/presentation/pages/login_page.dart';
import '../constants/constant.dart';
import '../widgets/right_logo.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.all(30.0).copyWith(top: 200, right: 0, bottom: 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
           child: RightLogo(),
            ),
            const Text(
              'Get things done.',
              style: kTitleTextStyle,),
            const SizedBox(height: 16),
            const Text(
              'Just a click away from \n planning your tasks.',
              style: kSubtitleTextStyle
            ),
            const Spacer(),
            Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1000),
                    ),
                  ),
                  child: Center(
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
