import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Addnotescreen extends StatefulWidget {
  const Addnotescreen({super.key});

  @override
  State<Addnotescreen> createState() => _AddnotescreenState();
}

class _AddnotescreenState extends State<Addnotescreen> {
  bool _isLoading = false;
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descriptioncontroller = TextEditingController();
  final User? currentuser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _titlecontroller.dispose();
    _descriptioncontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('New Note', style: TextStyle(color: Color(0xff6A3EA1))),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Color(0xff6A3EA1)),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Divider(thickness: 1),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text('Title', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _titlecontroller,
                        decoration: InputDecoration(
                          hintText: 'Enter the Title',
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
                      SizedBox(height: 25),
                      Text('Description', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      TextField(
                        controller: _descriptioncontroller,
                        maxLines: 8,
                        minLines: 6,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                          hintText: 'Enter your Note here ',
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
                      SizedBox(height: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          backgroundColor: Color(0xff6A3EA1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () async {
                                if (_titlecontroller.text.isEmpty) {
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
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentuser!.uid)
                                      .collection('notes')
                                      .add({
                                        'title': _titlecontroller.text.trim(),
                                        'description': _descriptioncontroller.text.trim(),
                                        'createdAt': DateTime.now(),
                                      });

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
                                  Text('   Save Note', style: TextStyle(fontSize: 16, color: Colors.white)),
                                  Opacity(opacity: 0, child: Icon(Icons.arrow_forward, color: Colors.white)),
                                ],
                              ),
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
