import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  // Android
  File? image;

  // Web
  Uint8List? photo;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (kIsWeb) {
      photo = await pickedFile!.readAsBytes();
    }

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile screen '), backgroundColor: Colors.amber),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                pickImage();
              },
              child: Text('Pick Image'),
            ),
            Container(
              height: 200,
              width: 200,
              color: Colors.grey,
              // mobile
              // child: Center(child: image != null ? Image.file(image!) : Text('No Image Selected ')),
              // Web
              child: Center(child: photo != null ? Image.memory(photo!) : Text('No Image Selected ')),
            ),
          ],
        ),
      ),
    );
  }
}
