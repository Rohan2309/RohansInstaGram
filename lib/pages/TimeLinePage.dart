import 'package:buddiesgram/models/user.dart';
import 'package:buddiesgram/pages/HomePage.dart';
import 'package:buddiesgram/widgets/HeaderWidget.dart';
import 'package:buddiesgram/widgets/PostWidget.dart';
import 'package:buddiesgram/widgets/ProgressWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';





class TimeLinePage extends StatefulWidget
{
  final User gCurrentUser;

  TimeLinePage({this.gCurrentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}




class _TimeLinePageState extends State<TimeLinePage>
{
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  retrieveTimeLine() async
  {
    QuerySnapshot querySnapshot = await timelineRefrence.document(widget.gCurrentUser.id)
        .collection("timelinePosts").orderBy("timestamp", descending: true).getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((document) => Post.fromDocument(document)).toList();
    
    setState(() {
      this.posts = allPosts;
    });
  }

  retrieveFollowings() async
  {
    QuerySnapshot querySnapshot = await followingRefrence.document(currentUser.id).collection("userFollowing").getDocuments();
    
    setState(() {
      followingsList = querySnapshot.documents.map((document) => document.documentID).toList();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveTimeLine();
    retrieveFollowings();
  }


  createUserTimeLine()
  {
    if(posts == null)
    {
      return circularProgress();
    }
    else
    {
      return ListView(children: posts,);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      key: _scaffoldKey,

      appBar: header(context, isAppTitle: true,),

      body: RefreshIndicator(child: createUserTimeLine(), onRefresh: () => retrieveTimeLine()),
    );
  }
}
