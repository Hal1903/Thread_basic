import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sns/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sns/pages/wall_post.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ! means non-nullable variable although the type itself allows null
  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void logOut(){
    FirebaseAuth.instance.signOut();
  }
  void postMsg(){
    // only post if not blank
    if (textController.text.isNotEmpty){
      // store in firebase
      print('UserEmail: ${user.email}');
      print('Message: ${textController.text}');
      print('TimeStamp: ${Timestamp.now()}');
      FirebaseFirestore.instance.collection("User_Posts").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [], // initially no one likes yet
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: logOut, 
          icon: const Icon(Icons.logout)),
        ],
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.grey[350],
      body: Center(
        child: Column(
          children: [
        // wall
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // can name anyhow
                // constantly taking instance
                stream: FirebaseFirestore.instance
                  .collection("User_Posts") // specifying what I want to retrieve
                  .orderBy("TimeStamp", descending: false)
                  .snapshots(), // snapshots listens for changes in the collection
                  builder: (context, snapshot) {
                    if (snapshot.hasData){
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                        // get the Msg, docs is a list of documents in snapshot
                          final post = snapshot.data!.docs[index]; 
                        /*{            database may have a struc like
                            "Message": "Hello, world!",
                            "UserEmail": "example@email.com",
                            // other fields...
                          }                          */
                          return WallPost(
                            msg: post['Message'], user: post['UserEmail'],
                            postId: post.id, likes: List<String>.from(post['Likes'] ?? []),
                            // ?? means, if it is null return empty list
                          );
                        })
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ),

        // post msg
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextField(
                      controller: textController,
                      hintText: "Write something to post...",
                      obscureText: false,
                    ),
                  ),
                  // post button
                  IconButton(
                    onPressed: postMsg,
                    icon: const Icon(Icons.arrow_circle_up),
                  ),
                ],
              ),
            ),
        
          ],
        ),
      ), 
        // child: Text(
        //   "Logged in as ${user.email}", 
        //   style: const TextStyle(fontSize: 20),
        // ),
    );
  }
}