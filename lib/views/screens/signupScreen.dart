// ignore_for_file: unused_field, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:orienta_notes/views/bottom_nav_bar/bottomNavBar.dart';
import 'package:orienta_notes/views/screens/loginScreen.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  File? pickedimage;

  Uint8List? photo;
  String profileImage = '';
  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  var _uploadedImageUrl;

  final TextEditingController _fullnamecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _retypepassword = TextEditingController();

  // ignore: prefer_final_fields
  bool _isLoading = false;

  @override
  void dispose() {
    _fullnamecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _retypepassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                snap: true,
                pinned: false,

                backgroundColor: Colors.white,
                title: Text(
                  'Back to Login',
                  style: TextStyle(color: Color(0xff6A3EA1), fontSize: 18, fontWeight: FontWeight.w500),
                ),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xff6A3EA1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Register', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                      SizedBox(height: 12),
                      Text('And start taking notes', style: TextStyle(fontSize: 16, color: Colors.grey)),

                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedfile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              // if (kIsWeb) {
                              //   photo = await pickedfile!.readAsBytes();
                              // }
                              if (pickedfile != null) {
                                pickedimage = File(pickedfile.path);
                              }

                              setState(() {});

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
                                request.files.add(
                                  http.MultipartFile.fromBytes('file', photo!, filename: 'image.png'),
                                );
                                request.files.add(
                                  http.MultipartFile.fromBytes(
                                    'img',
                                    pickedimage!.readAsBytesSync(),
                                    filename: 'photo.jpg',
                                  ),
                                );
                                // Send the request.
                                final response = await request.send();

                                if (response.statusCode == 200) {
                                  final responseString = await response.stream.bytesToString();
                                  final jsonMap = json.decode(responseString);

                                  setState(() {
                                    profileImage = jsonMap['secure_url'];
                                    _uploadedImageUrl = profileImage;
                                  });
                                  print(null);
                                  print("Image uploaded successfully: $profileImage");
                                } else {
                                  print('Failed to upload Image: ${response.statusCode}');
                                  print('Failed: ${response.reasonPhrase}');
                                }
                              } catch (e) {
                                print("Error uploading image: $e");
                              }
                            },

                            child: Container(
                              padding: EdgeInsets.only(bottom: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                boxShadow: [BoxShadow(color: Colors.grey.shade700, blurRadius: 3)],
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: pickedimage != null ? FileImage(pickedimage!) : null,
                                backgroundColor: Color(0xff6A3EA1),
                                child: pickedimage == null
                                    ? Icon(Icons.camera_alt_outlined, color: Colors.grey.shade200)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),

                      Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _fullnamecontroller,
                        decoration: InputDecoration(
                          hintText: 'Example: Muhammad Zeeshan',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6A3EA1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Email Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _emailcontroller,
                        decoration: InputDecoration(
                          hintText: 'Example: zeeshan@gmail.com',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6A3EA1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _passwordcontroller,
                        decoration: InputDecoration(
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6A3EA1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Retype Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _retypepassword,
                        decoration: InputDecoration(
                          hintText: '********',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff6A3EA1)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff6A3EA1),

                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (pickedimage == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please pick the profile picture!'),
                                      backgroundColor: Color(0xff6A3EA1),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }
                                if (_fullnamecontroller.text.isEmpty ||
                                    _emailcontroller.text.isEmpty ||
                                    _passwordcontroller.text.isEmpty ||
                                    _retypepassword.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please fill all the fields!'),
                                      backgroundColor: Color(0xff6A3EA1),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  return;
                                }
                                if (_passwordcontroller.text != _retypepassword.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Passwords don\'t match '),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );

                                  return;
                                }

                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  final url = Uri.parse("https://api.cloudinary.com/v1_1/dabaru8co/upload");
                                  final request = http.MultipartRequest('Post', url);
                                  request.fields['upload_preset'] = 'image-upload';
                                  request.files.add(await http.MultipartFile.fromPath('file', pickedimage!.path));

                                  final response = await request.send();
                                  if (response.statusCode == 200) {
                                    final responseData = await response.stream.bytesToString();
                                    _uploadedImageUrl = jsonDecode(responseData)['secure_url'];
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${response.reasonPhrase}'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('$e'),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 5),
                                    ),
                                  );
                                }
                                try {
                                  UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _emailcontroller.text.trim(),
                                    password: _passwordcontroller.text.trim(),
                                  );

                                  await FirebaseFirestore.instance.collection('users').doc(cred.user!.uid).set({
                                    'Fullname': _fullnamecontroller.text,
                                    'Profile Picture': _uploadedImageUrl,
                                    'Email': _emailcontroller.text,
                                    'uid': cred.user!.uid,
                                    'createdAt': FieldValue.serverTimestamp(),
                                    // "usercreationtime": DateTime.now(),
                                  });

                                  if (context.mounted) {
                                    // ignore: unawaited_futures
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => Bottomnavbar()),
                                      (route) => false,
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${e.message}'),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                        duration: Duration(seconds: 7),
                                      ),
                                    );
                                  }
                                  // SnackBar(content: Text(e.toString()));
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(builder: (context) => Bottomnavbar()),
                                // );
                              },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                            const Positioned(right: 0, child: Icon(Icons.arrow_forward, color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Or', style: TextStyle(color: Colors.grey.shade600)),
                          ),
                          Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.grey.shade50,
                          side: BorderSide(color: Colors.grey.shade400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png', height: 24, width: 24),
                            const SizedBox(width: 12),
                            const Text(
                              ' Register with Google',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                            },
                            child: Text(
                              'Already have an account? Login here',
                              style: TextStyle(fontSize: 16, color: Color(0xff6A3EA1)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
