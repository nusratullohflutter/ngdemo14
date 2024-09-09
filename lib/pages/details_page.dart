import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ngdemo14/models/post_model.dart';
import 'package:ngdemo14/services/db_service.dart';
import 'package:ngdemo14/services/file_service.dart';
import 'package:ngdemo14/services/log_service.dart';

import '../services/prefs_service.dart';
import '../services/utils_service.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isLoading = false;
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  File? _image;
  final picker = ImagePicker();

  _addNewPost() async {
    String title = titleController.text.toString().trim();
    String content = contentController.text.toString().trim();
    if (title.isEmpty || content.isEmpty) return;
    if (_image == null) {
      Utils.fireToast("Please select an image from your gallery");
      return;
    }

    var userId = await Prefs.loadUserId();
    Post post = Post(userId, title, content, "");

    _apiUploadImage(post);
  }

  _apiUploadImage(Post post) async {
    setState(() {
      isLoading = true;
    });
    String img_url = await FileService.uploadPostImage(_image!);
    post.img_url = img_url;
    _apiAddPost(post);
  }

  _apiAddPost(Post post) async {
    await DbService.storePost(post);
    _backToFinish();
  }

  _backToFinish() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop(true);
  }

  Future _getImage() async {
    LogService.i("_getImage");
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    LogService.i("pickedFile");
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        LogService.e('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Create Post"),
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("assets/images/ic_camera.png"),
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(hintText: "Content"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: () {
                        _addNewPost();
                      },
                      color: Colors.blue,
                      child: Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SizedBox.shrink(),
          ],
        ));
  }
}
