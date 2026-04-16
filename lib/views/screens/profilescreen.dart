// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orienta_notes/views/screens/editprofilescreen.dart';
import 'package:orienta_notes/views/screens/loginScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

class _ProfilescreenState extends State<Profilescreen> {
  String? name;
  String? profileImageUrl;
  // File? _selectedImage;
  final User? currentuser = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text('Settings', style: TextStyle(fontSize: 25)),
        centerTitle: true,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(3), child: Divider(thickness: 0.5, height: 1)),

        // elevation: 2,
        // scrolledUnderElevation: 1,
        // flexibleSpace: Icon(Icons.telegram),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.white,
        //   statusBarIconBrightness: Brightness.dark,
        // ),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await FirebaseAuth.instance.signOut();
        //       await GoogleSignIn().signOut();

        //       if (mounted) {
        //         // ignore: unawaited_futures
        //         Navigator.pushAndRemoveUntil(
        //           context,
        //           MaterialPageRoute(builder: (context) => Loginscreen()),
        //           (route) => false,
        //         );
        //       }
        //     },
        //     icon: Icon(Icons.logout, color: Colors.red),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(currentuser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(strokeWidth: 5, color: Color(0xff6A3EA1)),
                ),
              );
            }

            if (snapshot.hasError) {
              return Text('Error Loading Name');
            }

            if (snapshot.hasData && snapshot.data!.exists) {
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

              String fullName = data['Fullname'] ?? 'User';
              name = fullName;

              String? imageurl = data['Profile Picture'];
              profileImageUrl = imageurl;

              // Text(fullName, style: TextStyle(fontSize: 22));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Divider(thickness: 0.5, color: Colors.grey.shade500),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),

                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                              child: profileImageUrl != null ? null : Icon(Icons.person, color: Colors.white),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name ?? '',
                                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                                    // softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // FittedBox(
                                  //   fit: BoxFit.scaleDown,
                                  //   child: Text(
                                  //     name ?? '',
                                  //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                  //     // softWrap: true,
                                  //     maxLines: 1,
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/mail.svg',
                                        colorFilter: ColorFilter.mode(Colors.grey.shade600, BlendMode.srcIn),
                                        width: 19,
                                      ),
                                      // Icon(CupertinoIcons.mail, color: Colors.grey.shade600, size: 16),
                                      Expanded(
                                        child: Text(
                                          '  ${email ?? "no email"}',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 20),
                        // GestureDetector(
                        //   onTap: () async {
                        //     final PickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                        //     if (PickedFile == null) return;

                        //     setState(() {
                        //       _selectedImage = File(PickedFile.path);
                        //     });
                        //   },
                        //   child: CircleAvatar(
                        // CircleAvatar(
                        //   radius: 60,
                        //   backgroundColor: Color(0xff6A3EA1),
                        //   backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl!) : null,
                        //   child: profileImageUrl != null ? null : Icon(Icons.person, color: Colors.white),
                        // ),

                        // SizedBox(height: 15),
                        // Text(name!, style: TextStyle(fontSize: 22)),
                        // SizedBox(height: 10),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Icon(CupertinoIcons.mail, color: Colors.grey.shade500, size: 18),
                        //     Text(' $email ', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                        //   ],
                        // ),
                        SizedBox(height: 35),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            foregroundColor: Color(0xff6A3EA1),
                            // foregroundColor: Colors.amber,
                            side: BorderSide(color: Color(0xff6A3EA1), width: 1.3),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(19)),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Editprofilescreen(userName: name, userProfileImage: profileImageUrl),
                              ),
                            );

                            setState(() {});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/pencil-alt.svg', width: 23),
                              // Icon(Icons.edit_note_outlined),
                              Text('  Edit Profile', style: TextStyle(fontSize: 17, color: Color(0xff6A3EA1))),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),
                        // Divider(thickness: 3.5, color: Color(0xff6A3EA1)),
                        Divider(thickness: 0.5, color: Colors.grey.shade500),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('APP SETTINGS', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
                          ],
                        ),
                        SizedBox(height: 15),
                        ListTile(
                          leading: SvgPicture.asset('assets/images/lock-closed.svg', width: 30),
                          title: Text('Change Password', style: TextStyle(color: Colors.black, fontSize: 19)),
                          trailing: SvgPicture.asset(
                            'assets/images/cheveron-right.svg',
                            width: 20,
                            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          ),
                          onTap: () {},
                        ),

                        SizedBox(height: 10),
                        ListTile(
                          leading: SvgPicture.asset(
                            'assets/images/text-size.svg',
                            width: 30,
                            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                          ),
                          title: Text('Text Size', style: TextStyle(color: Colors.black, fontSize: 19)),
                          trailing: Text('Medium', style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
                          onTap: () {},
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          leading: SvgPicture.asset('assets/images/bell.svg', width: 30),
                          title: Text('Notifications', style: TextStyle(color: Colors.black, fontSize: 19)),
                          trailing: Text(
                            'All active',
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                          ),

                          onTap: () {},
                        ),

                        SizedBox(height: 15),
                        Divider(thickness: 0.5, color: Colors.grey),
                        SizedBox(height: 10),

                        // Gonna this list tile later on for logout with pop op alert icon
                        ListTile(
                          leading: SvgPicture.asset('assets/images/Icon.svg', width: 25),
                          title: Text(
                            ' Log Out',
                            style: TextStyle(color: Color(0xffCE3A54), fontSize: 19, fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(20)),
                                  title: const Text(
                                    'Log Out',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  ),
                                  content: Text(
                                    "Are you sure you want to log out from the application?",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey, fontSize: 16),
                                  ),
                                  actions: [OutlinedButton(onPressed: () {}, child: Text('Cancel'))],
                                );
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: SvgPicture.asset("assets/images/Icon.svg", width: 25),
                          // title: Text('Notifications', style: TextStyle(color: Colors.black, fontSize: 19)),
                          title: Text(
                            ' Log Out',
                            style: TextStyle(color: Color(0xffCE3A54), fontSize: 19, fontWeight: FontWeight.w600),
                          ),

                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            await GoogleSignIn().signOut();

                            if (mounted) {
                              // ignore: unawaited_futures
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Loginscreen()),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
