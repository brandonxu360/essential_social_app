import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essential_app/components/my_list_tile.dart';
import 'package:essential_app/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:essential_app/components/my_drawer.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Users").snapshots(),
          builder: (context, snapshot) {
            // Errors
            if (snapshot.hasError) {
              displayMessageToUser("Something went wrong", context);
            }

            // Show loading circle
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            }

            if (snapshot.data == null) {
              return const Text("No data");
            }

            // Get all users
            final users = snapshot.data!.docs;

            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  // Get individual user
                  final user = users[index];

                  // Get data from each user
                  String username = user['username'];
                  String email = user['email'];

                  return MyListTile(title: username, subtitle: email);
                });
          },
        ),
      ),
      drawer: const MyDrawer(
        currPage: 3,
      ),
    );
  }
}
