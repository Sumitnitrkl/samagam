import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samagam_hack/home/msg_cleaners.dart';

import 'package:samagam_hack/services/user-type-db.dart';

import 'authenticate/authenticate.dart';

import 'home/homescreen.dart';
import 'home/students_category_screen.dart';
import 'home/worker.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      // Listen to the userType stream
      return StreamBuilder<String>(
        stream: DatabaseService().streamUserType(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            // Get the userType from the stream
            String userType = snapshot.data ?? '';

            // Redirect based on userType
            switch (userType) {
              case 'plumber':
                return Worker(
                  category: 'Plumber',
                );
              case 'electrician':
                return Worker(
                  category: 'Electrician',
                );
              // Add more cases for other user types
              case 'cleaner':
                return MessageForCleaners(
                  category: 'Cleaner',
                );
              case 'students':
                return HomeScreen();
              // Create a screen for unknown user types
              default:
                return CircularProgressIndicator();
            }
          } else {
            // Show loading screen while waiting for data
            return CircularProgressIndicator(); // Create a loading widget for waiting state
          }
        },
      );
    }
  }
}
