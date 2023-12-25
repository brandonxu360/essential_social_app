import 'package:essential_app/auth/login_or_register.dart';
import 'package:essential_app/helper/page_transitions.dart';
import 'package:essential_app/pages/home_page.dart';
import 'package:essential_app/pages/login_page.dart';
import 'package:essential_app/pages/profile_page.dart';
import 'package:essential_app/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  final int currPage; //

  const MyDrawer({super.key, required this.currPage});

  // Logout
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        // Outermost column that holds drawer header and intermediate column
        children: [
          // Drawer header
          const DrawerHeader(child: Icon(Icons.favorite)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Column(
                  // Intermediate column that holds column of tiles (home, profile, users) and logout tile
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(children: [
                      // Innnermost column that holds home, profile, and user tiles
                      // Home tile
                      ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('H O M E'),
                          onTap: () {
                            Navigator.pop(context);
                            if (currPage != 1) {
                              Navigator.pushReplacementNamed(
                                  context, '/home_page');
                            }
                          }),

                      // Profile tile
                      ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text("P R O F I L E"),
                          onTap: () {
                            Navigator.of(context).pop();
                            if (currPage != 2) {
                              Navigator.pushReplacementNamed(
                                  context, '/profile_page');
                            }
                          }),

                      // Users tile
                      ListTile(
                          leading: const Icon(Icons.group),
                          title: const Text("U S E R S"),
                          onTap: () {
                            Navigator.pop(context);
                            if (currPage != 3) {
                              Navigator.pushReplacementNamed(
                                  context, '/users_page');
                            }
                          }),
                    ]),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text("L O G O U T"),
                            onTap: () {
                              // Logout function
                              logout();

                              // Navigate back to the authentication class which will keep the user in home if the logout function did not work
                              Navigator.pushReplacementNamed(context, '/auth');
                            }))
                  ]),
            ),
          ),
          // Logout tile
        ],
      ),
    );
  }
}
