import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:orienta_notes/views/screens/editnotescreen.dart';
import 'package:orienta_notes/views/screens/notedetailscreen.dart';
import 'package:orienta_notes/widgets/cardrandomcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  // bool? _isExisted;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    // Image.asset('assets/images/Illustration (1).png', scale: 0.8),
                    SvgPicture.asset(
                      'assets/images/Illustration.svg', // Replace with your actual file name
                      height: 330, // Best practice: Give SVGs a specific height or width
                      width: 250,
                    ),
                    Text('Start Your Journey', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                    SizedBox(height: 16),
                    Text(
                      'Every big step start with small step.\n    Notes your first idea and start\n    \t \t \t\t\t\t\t\t\t\t\t \t  your journey!',
                    ),
                    SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset('assets/images/Arrow.png', scale: 0.6, color: Colors.black),
                        SizedBox(width: 35),
                        SvgPicture.asset('assets/images/Arrow.svg', height: 135, width: 250),
                        SizedBox(width: 70),
                      ],
                    ),
                    // Icon(Icons.note_alt_outlined, size: 60, color: Colors.grey),
                    // Text("No notes yet!", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            padding: EdgeInsets.all(16),

            itemBuilder: (context, index) {
              var noteSnapshot = snapshot.data!.docs[index];
              Map<String, dynamic> noteData = noteSnapshot.data();
              String noteId = noteSnapshot.id;
              final Color bgcolor = ColorHelper.getNoteColor(index);
              final Color textcolor = ColorHelper.getTextColorForBackground(bgcolor);
              return Dismissible(
                key: Key(noteId),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser!.uid)
                      .collection('notes')
                      .doc(noteId)
                      .delete();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Note deleted'),
                      duration: Duration(seconds: 1),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  color: Colors.transparent,
                  child: Icon(Icons.delete),
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNoteScreen(
                          currentTitle: noteData['title'],
                          currentDesc: noteData['description'],
                          docId: noteId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    color: bgcolor,
                    // color: Color(0xffF3E5F5),
                    // color: Color(0xff6A3EA1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                      title: Text(
                        noteData['title'],
                        style: TextStyle(color: textcolor, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Text(
                        noteData['description'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textcolor.withValues(alpha: 0.5)),
                      ),
                      // trailing: IconButton(
                      //   icon: Icon(Icons.delete, color: Color(0xff6A3EA1)),
                      //   onPressed: () async {
                      //     await FirebaseFirestore.instance
                      //         .collection('users')
                      //         .doc(currentUser!.uid)
                      //         .collection('notes')
                      //         .doc(noteId)
                      //         .delete();
                      //   },
                      // ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
