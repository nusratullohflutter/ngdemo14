import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo14/models/post_model.dart';
import 'package:ngdemo14/pages/signin_page.dart';
import 'package:ngdemo14/services/auth_service.dart';
import 'package:ngdemo14/services/log_service.dart';
import 'package:ngdemo14/services/prefs_service.dart';

import '../services/db_service.dart';
import 'details_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "home_page";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Post> items = [];

  Future _callDetailsPage() async {
    bool results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return const DetailsPage();
    }));
    if (results) {
      _apiLoadPosts();
    }
  }

  _apiLoadPosts() async {
    setState(() {
      isLoading = true;
    });
    List<Post> posts = await DbService.loadPosts();
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _apiLoadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Post List"),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return _itemOfPost(items[index]);
            },
          ),
          isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _callDetailsPage();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            CachedNetworkImage(
              width: 70,
              height: 70,
              imageUrl: post.img_url!,
              placeholder: (context, url) => Container(
                color: Colors.grey.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.withOpacity(0.5),
              ),
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  post.content,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ));
  }
}