// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:orienta_notes/views/bottom_nav_bar/bottomNavBar.dart';
import 'package:orienta_notes/views/screens/homescreen.dart';
import 'package:orienta_notes/views/screens/signupScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _isLoading = false;

  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> singinwithGoogle() async {
    try {
      // Trigger the Google Sign-In flow.
      final googleUser = await _googleSignIn.signIn();

      // User canceled the sign-in.
      if (googleUser == null) return;

      // Retrieve the authentication details from the Google account.
      final googleAuth = await googleUser.authentication;

      // Create a new credential using the Google authentication details.
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential.
      final userCredential = await _auth.signInWithCredential(credential);

      String? name = userCredential.user!.displayName;
      String? email = userCredential.user!.email;
      String? profilePic = userCredential.user!.photoURL;

      print(name);
      print(email);
      print(profilePic);

      // Return the authenticated user.
      // return userCredential.user;
    } catch (e) {
      // Print the error and return null if an exception occurs.
      print("Sign-in error: $e");
      // ignore: avoid_returning_null_for_void
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  Text('Lets Login', style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('And notes your ideas', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 32),
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
                  SizedBox(height: 32),
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
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size(0, 30),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Forgot Password',
                            style: TextStyle(fontSize: 16, color: Color(0xff6A3EA1), height: 1.0),
                          ),

                          Transform.translate(
                            offset: const Offset(0, 0.1),
                            child: Container(height: 1.5, color: const Color(0xff6A3EA1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_emailcontroller.text.isEmpty || _passwordcontroller.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill all fields'),
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
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: _emailcontroller.text.trim(),
                                password: _passwordcontroller.text.trim(),
                              );
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
                                    content: Text(e.toString()),
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
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }

                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Bottomnavbar()));
                          },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Color(0xff6A3EA1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Opacity(opacity: 0, child: Icon(Icons.arrow_forward)),
                              Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                              Icon(Icons.arrow_forward, color: Colors.white),
                            ],
                          ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                      Text('  Or  ', style: TextStyle(color: Colors.grey.shade400)),
                      Expanded(child: Divider(thickness: 1, color: Colors.grey.shade400)),
                    ],
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      // await singinwithGoogle();

                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final googleUser = await _googleSignIn.signIn();
                        if (googleUser == null) {
                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }

                        final googleAuth = await googleUser.authentication;

                        final credentials = GoogleAuthProvider.credential(
                          accessToken: googleAuth.accessToken,
                          idToken: googleAuth.idToken,
                        );
                        final UserCredential = await _auth.signInWithCredential(credentials);

                        final user = UserCredential.user;
                        if (user != null) {
                          final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
                          if (!userDoc.exists) {
                            FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                              'Fullname': user.displayName,
                              'Email': user.email,
                              'uid': user.uid,
                              'Profile Picture': user.photoURL,
                              'createdAt': FieldValue.serverTimestamp(),
                            });
                          }
                        }
                        if (mounted) {
                          await Navigator.pushAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(builder: (context) => Bottomnavbar()),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('$e'),
                            duration: Duration(seconds: 5),
                            backgroundColor: Colors.red,
                          ),
                        );
                        // ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(content: Text('$e'), actions: ));
                      }
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.grey.shade50,
                      side: BorderSide(color: Colors.grey.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: _isLoading == true
                        ? CircularProgressIndicator(color: Colors.amber)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/google.png', height: 24, width: 24),
                              SizedBox(width: 12),
                              Text(' Login with Google', style: TextStyle(fontSize: 16, color: Colors.black)),
                            ],
                          ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          minimumSize: const Size(300, 30),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Signupscreen()));
                        },
                        child: Text(
                          'Don\'t have any account? Register here',
                          style: TextStyle(fontSize: 16, color: Color(0xff6A3EA1)),
                        ),
                      ),
                    ],
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
