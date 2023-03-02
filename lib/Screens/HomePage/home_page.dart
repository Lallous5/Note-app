// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:masteringflutterwithfirebase/Screens/HomePage/add_notes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masteringflutterwithfirebase/Screens/HomePage/edit_notes.dart';
import 'package:masteringflutterwithfirebase/Screens/HomePage/view_note.dart';
import 'package:masteringflutterwithfirebase/Screens/Welcome/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../constants.dart';
import '../Login/components/const_components.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");
  List<Color> colors = [
    Colors.deepOrange,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrangeAccent,
  ];
  var fbm = FirebaseMessaging.instance;

  // initialMessage() async {
  //   var message = FirebaseMessaging.instance.getInitialMessage();

  //   if (message != null) {
  //     Get.to(() => AddNotes());
  //   }
  // }

  @override
  void initState() {
    // initialMessage();
    fbm.getToken().then((token) {
      print("/-/-/-/-//-token/-/-/-/-//-");
      print(token);
      print("/-/*/*///-//--/-------/-/-");
    });
    FirebaseMessaging.onMessage.listen((event) {
      AwesomeDialog(
        context: context,
        body: Text(
          "${event.notification!.body}",
          style: TextStyle(
            fontSize: 22,
          ),
        ),
      ).show();
      print("/-/-/-/-//-notification/-/-/-/-//-");
      print("${event.notification!.body}");
      print("/-/*/*///-//--/-------/-/-");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.to(() => AddNotes());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Text(""),
        title: const Text("Welcome Home"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => const WelcomeScreen());
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Get.to(() => const AddNotes());
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('notes')
            .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    await notesRef.doc(documentSnapshot.id).delete();
                  },
                  child: ListNote(
                    notes: documentSnapshot,
                    docId: documentSnapshot.id,
                    colors:
                        Color(Random().nextInt(0xffffffff)).withOpacity(0.5),
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Text("ERROR MISSING DATA");
          }
          return const Center(child: ConstComponents.loadingIndicator);
        },
      ),
    );
  }
}

class ListNote extends StatelessWidget {
  const ListNote(
      {required this.notes, required this.docId, required this.colors});
  final docId;
  final notes;
  final colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ViewNotes(
            notes: notes,
            colors: Color(Random().nextInt(0xffffffff)).withOpacity(0.9),
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: colors),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      notes['title'],
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      notes['body'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                  ),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.to(() => EditeNotes(
                          docId: docId,
                          list: notes,
                        ));
                      },
                      icon: Icon(
                        Icons.edit_note,
                        size: 33,
                      ))
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

// ListTile(
//                 title: Text(
//                   "${notes['title']}",
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   "${notes['body']}",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.normal,
//                   ),
//                 ),
//                 trailing: IconButton(
//                   onPressed: () {
//                     Get.to(() => EditeNotes(
//                           docId: docId,
//                           list: notes,
//                         ));
//                   },
//                   icon: const Icon(Icons.edit),
//                 ),
//               ),