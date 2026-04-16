import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Userprofilepractice extends StatefulWidget {
  const Userprofilepractice({super.key});

  @override
  State<Userprofilepractice> createState() => _UserprofilepracticeState();
}

class _UserprofilepracticeState extends State<Userprofilepractice> {
  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  var uploadedImageUrl;

  File? pickedimage;

  Uint8List? photo;

  Future<void> pickImage() async {
    final pickedfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (kIsWeb) {
      photo = await pickedfile!.readAsBytes();
    }
    if (pickedfile != null) {
      pickedimage = File(pickedfile.path);
    }

    setState(() {});
  }

  String profileImage = '';

  Future<void> uploadImage() async {
    try {
      // if (   photo == null ) {
      //   throw Exception("No Image Selected");
      // }

      // Convert Uint8List to a file-like structure for upload.
      final url = Uri.parse("https://api.cloudinary.com/v1_1/dabaru8co/upload");

      // Create the request.
      final request = http.MultipartRequest('POST', url);

      // Add fields for Cloudinary.
      request.fields['upload_preset'] = 'image-upload';

      // Add the image as a file.
      request.files.add(http.MultipartFile.fromBytes('file', photo!, filename: 'image.png'));
      request.files.add(
        http.MultipartFile.fromBytes('img', pickedimage!.readAsBytesSync(), filename: 'photo.jpg'),
      );
      // Send the request.
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final jsonMap = json.decode(responseString);

        setState(() {
          profileImage = jsonMap['secure_url'];
          uploadedImageUrl = profileImage;
        });
        print("Image uploaded successfully: $profileImage");
      } else {
        print("Failed to upload Image: ${response.statusCode}");
        print('Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile Screen'), backgroundColor: Colors.amber),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: []),
          ElevatedButton(
            onPressed: () {
              pickImage();
            },
            child: Text("Pick Image"),
          ),
          if (kIsWeb)
            Container(
              width: 200,
              height: 200,
              child: Center(child: photo != null ? Image.memory(photo!) : Text('No image selected')),
            ),
          if (!kIsWeb)
            Container(
              width: 200,
              height: 200,
              child: Center(child: pickedimage != null ? Image.file(pickedimage!) : Text('No image selected')),
            ),

          ElevatedButton(
            onPressed: () async {
              try {
                await uploadImage();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$uploadedImageUrl'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 5),
                  ),
                );
              } catch (e) {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$e'), backgroundColor: Colors.red, duration: Duration(seconds: 5)),
                );
              }
            },
            child: Text('Upload Image'),
          ),
        ],
      ),
    );
  }
}
