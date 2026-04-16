import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orienta_notes/views/screens/profilescreen.dart';

class Editprofilescreen extends StatefulWidget {
  final String? userName;
  final String? userProfileImage;
  const Editprofilescreen({super.key, required this.userName, required this.userProfileImage});

  @override
  State<Editprofilescreen> createState() => _EditprofilescreenState();
}

class _EditprofilescreenState extends State<Editprofilescreen> {
  File? pickedImage;
  bool _isLoading = false;
  late TextEditingController _fullnameController;
  @override
  void initState() {
    super.initState();

    _fullnameController = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    super.dispose();
  }

  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
          centerTitle: true,
          leadingWidth: 120,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 10),
                SvgPicture.asset('assets/images/backIcon.svg', width: 8),
                // Icon(Icons.arrow_back, color: Color(0xff6A3EA1)),
                Text(
                  '  Settings',
                  style: TextStyle(color: Color(0xff6A3EA1), fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          bottom: PreferredSize(preferredSize: Size.fromHeight(3), child: Divider(thickness: 0.5, height: 1)),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Divider(thickness: 0.4, color: Colors.grey.shade500),
                  SizedBox(height: 7),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: pickedImage != null
                            ? FileImage(pickedImage!)
                            : NetworkImage(widget.userProfileImage!),
                      ),
                    ],
                  ),
                  SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          overlayColor: Color(0xff6A3EA1),
                          side: BorderSide(color: Color(0xff6A3EA1)),
                        ),
                        onPressed: () async {
                          final pickedfile = await ImagePicker().pickImage(source: ImageSource.gallery);

                          if (pickedfile != null) {
                            setState(() {
                              pickedImage = File(pickedfile.path);
                            });
                          }
                        },
                        child: Row(
                          children: [SvgPicture.asset('assets/images/pencil-alt.svg'), Text('  Change Image')],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(thickness: 0.3, color: Colors.grey.shade500),
                  SizedBox(height: 20),
                  Text('Full Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  TextField(
                    controller: _fullnameController,

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
                  SizedBox(height: 45),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Color(0xff6A3EA1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final bool isNameChanged = _fullnameController.text.trim() != widget.userName;
                            final bool isImageChanged = pickedImage != null;

                            if (!isNameChanged && !isImageChanged) {
                              Navigator.pop(context);
                              return;
                            }
                            if (_fullnameController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please Fill the require field'),
                                  backgroundColor: Color(0xff6A3EA1),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _isLoading = true;
                            });

                            try {
                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
                                'Fullname': _fullnameController.text.trim(),
                              });
                              // await Future.delayed(const Duration(milliseconds: 600));
                              if (mounted) {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(
                                // ignore: use_build_context_synchronously
                                context,
                              ).showSnackBar(SnackBar(content: Text('$e'), backgroundColor: Colors.red));
                            }
                            // await Future.delayed(const Duration(milliseconds: 100));
                            await Future.delayed(Duration(milliseconds: 100));

                            setState(() {
                              _isLoading = false;
                            });
                          },
                    child: _isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 1,
                            color: Colors.grey,
                            backgroundColor: Color(0xff6A3EA1),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Opacity(opacity: 1, child: Icon(Icons.done, color: Colors.white)),
                              Text('   Save Changes', style: TextStyle(fontSize: 16, color: Colors.white)),
                              Opacity(opacity: 0, child: Icon(Icons.arrow_forward, color: Colors.white)),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
