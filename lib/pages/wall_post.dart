import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/like_button.dart';
import '../components/del_button.dart';

class WallPost extends StatefulWidget {
  final String msg;
  final String user;
  final String postId;
  final List<String> likes; // all the emails that (other or a user self) users liked
  //final String id = FirebaseFirestore.instance.collection("User_Posts").document(doc_id).;
  const WallPost({super.key, required this.msg, 
                  required this.user, required this.postId, required this.likes});

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  // user
  final currentUser = FirebaseAuth.instance.currentUser!; // non-nullable
  bool isLiked = false;

  @override
  void initState(){
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  Future<String> getEmail() async{
    print("CLICKED");
    DocumentReference emailRef = FirebaseFirestore.instance.collection('User_Posts').doc(widget.postId);
  // When we read data from Firestore, the result is often a DocumentSnapshot containing the data of a single document.
  // just a way they send a package of data
    DocumentSnapshot userData = await emailRef.get();
    print("Data: ${userData['UserEmail']}");
    return userData['UserEmail'];
  }

  void deletePost() async{
    // DocumentReference emailRef = FirebaseFirestore.instance.collection('User_Posts').doc(widget.postId);
  // When we read data from Firestore, the result is often a DocumentSnapshot containing the data of a single document.
  // just a way they send a package of data
    // DocumentSnapshot userEmail = await emailRef.get();
    // print('EMAIL: ${userEmail['UserEmail']}');
    print("currUser: ${currentUser.email}");
    if (currentUser.email == await getEmail()){
      setState(() {
        FirebaseFirestore.instance
            .collection('User_Posts')
            .doc(widget.postId)
            .delete();    
      });
    }
  }

  void toggleLike(){
    // local
    setState(() {
      isLiked = !isLiked;
    });
    // save like
    DocumentReference postRef = FirebaseFirestore.instance.collection('User_Posts').doc(widget.postId);
    if (isLiked){
      postRef.update({
          'Likes': FieldValue.arrayUnion([currentUser.email]),
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            children: [
              LikeButton(isLiked: isLiked, onTap: toggleLike),
              DeleteButton(onTap: deletePost),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.user, style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold,)),
              Text(widget.msg),
              // IconButton(onPressed: del, icon: const Icon(Icons.delete),)
            ],
          ),
        ],
      ),
    );
  }
}