// ignore_for_file: avoid_print, use_key_in_widget_constructors, prefer_typing_uninitialized_variables

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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");

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
          IconButton(
              onPressed: () {
                Get.to(() => const AddNotes());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('notes')
            .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) async {
                    await notesRef.doc(documentSnapshot.id).delete();
                    await FirebaseStorage.instance
                        .refFromURL(documentSnapshot['image'])
                        .delete()
                        .then((value) => AwesomeDialog(
                              context: context,
                              body: const Text("Please Choose Image"),
                              dialogType: DialogType.SUCCES,
                            ));
                  },
                  child: ListNote(
                    notes: documentSnapshot,
                    docId: documentSnapshot.id,
                  ),
                );
              },
            );
          }
          if (snapshot.hasError) {
            return const Text("Error");
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ListNote extends StatelessWidget {
  const ListNote({required this.notes, required this.docId});
  final docId;
  final notes;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ViewNotes(notes: notes)),
      child: Card(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Image.network(
                "${notes['image']}",
                fit: BoxFit.fill,
                height: 80,
              ),
            ),
            Expanded(
              flex: 3,
              child: ListTile(
                title: Text(
                  "${notes['title']}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${notes['body']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Get.to(() => EditeNotes(
                          docId: docId,
                          list: notes,
                        ));
                  },
                  icon: const Icon(Icons.edit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
