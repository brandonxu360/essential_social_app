import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essential_app/components/my_drawer.dart';
import 'package:essential_app/components/my_list_tile.dart';
import 'package:essential_app/components/my_post_button.dart';
import 'package:essential_app/components/my_textfield.dart';
import 'package:essential_app/database/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  // New posts textfield controller
  TextEditingController newPostController = TextEditingController();

  // Firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  HomePage({super.key});

  void postMessage() {
    // Only post message if there is something in the textfield
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    // Clear the controller
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('W A L L'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: Column(
        children: [
          //Textfield to write new posts
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                      hintText: "Say something!",
                      obscureText: false,
                      controller: newPostController),
                ),
                PostButton(onTap: postMessage),
              ],
            ),
          ),
          // Posts
          StreamBuilder(
              stream: database.getPostsStream(),
              builder: (context, snapshot) {
                // Show loading circle
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                }

                // Get all posts
                final posts = snapshot.data!.docs;

                // No data?
                if (snapshot.data == null || posts.isEmpty) {
                  return const Center(
                      child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text('No posts... Post something'),
                  ));
                }

                // Return as a list
                return Expanded(
                    child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
// Get each individual post
                          final post = posts[index];

// Get data from each post
                          String message = post['PostMessage'];
                          String userEmail = post['UserEmail'];
                          Timestamp timeStamp = post['TimeStamp'];

// Return as list tile
                          return MyListTile(
                              title: message, subtitle: userEmail);
                        }));
              })
        ],
      ),
      drawer: const MyDrawer(
        currPage: 1,
      ),
    );
  }
}
