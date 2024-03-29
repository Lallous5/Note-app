// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, use_build_context_synchronously

import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masteringflutterwithfirebase/Screens/HomePage/home_page.dart';
import 'package:masteringflutterwithfirebase/main.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../constants.dart';

class EditeNotes extends StatefulWidget {
  final docId;
  final list;
  EditeNotes({Key? key, this.docId, this.list}) : super(key: key);

  @override
  State<EditeNotes> createState() => _EditeNotesState();
}

class _EditeNotesState extends State<EditeNotes> {
  CollectionReference notesRef = FirebaseFirestore.instance.collection("notes");
  GlobalKey<FormState> formState = GlobalKey();
  // ignore: prefer_typing_uninitialized_variables
  var title, body;
  late Reference ref;

  editNote(context) async {
    var formData = formState.currentState;

      if (formData!.validate()) {
        loadingOverlay(context);
        formData.save();
        await notesRef
            .doc(widget.docId)
            .update({
              "title": title,
              "body": body,
            })
            .then((value) => Get.offAll(() => const HomePage()))
            .catchError((e) {
              print(e);
            });
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () async {
          await editNote(context);
        },
        child: const Icon(Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: widget.list['title'],
                      validator: (val) {
                        if (val!.length > 100) {
                          return "title cant to be larger than 100 letter";
                        } else if (val.length < 2) {
                          return "title cant to be less than 2 letter";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: kPrimaryColor,
                      onSaved: (val) {
                        title = val;
                      },
                      decoration: const InputDecoration(
                        hintText: "Title",
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Icon(Icons.note),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        initialValue: widget.list['body'],
                        validator: (val) {
                          if (val!.length > 320) {
                            return "body cant to be larger than 320 letter";
                          } else if (val.length < 2) {
                            return "body cant to be less than 2 letter";
                          } else {
                            return null;
                          }
                        },
                        maxLines: 10,
                        minLines: 1,
                        textInputAction: TextInputAction.done,
                        onSaved: (val) {
                          body = val;
                        },
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          hintText: "Body",
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(defaultPadding),
                            child: Icon(Icons.note_alt),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       showBottomSheet(context);
              //     },
              //     child: const Text("Edit Image")),
            ],
          ),
        ),
      ),
    );
  }

  // showBottomSheet(context) {
  //   return showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return Container(
  //           padding: const EdgeInsets.all(20),
  //           height: 200,
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               const Text(
  //                 "Edit Image",
  //                 style: TextStyle(
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               InkWell(
  //                 onTap: () async {
  //                   var picked = await ImagePicker()
  //                       .getImage(source: ImageSource.gallery);
  //                   if (picked != null) {
  //                     file = File(picked.path);
  //                     var ran = Random().nextInt(99999);

  //                     var nameimg = basename(picked.path);
  //                     nameimg = "$ran$nameimg";

  //                     ref =
  //                         FirebaseStorage.instance.ref("images").child(nameimg);
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: Container(
  //                   padding: const EdgeInsets.all(10),
  //                   width: double.infinity,
  //                   child: Row(
  //                     children: const [
  //                       Icon(
  //                         Icons.photo_outlined,
  //                         size: 30,
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text("From Gallery"),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               InkWell(
  //                 onTap: () async {
  //                   var picked = await ImagePicker()
  //                       .getImage(source: ImageSource.camera);
  //                   if (picked != null) {
  //                     file = File(picked.path);
  //                     var ran = Random().nextInt(99999);

  //                     var nameimg = basename(picked.path);
  //                     nameimg = "$ran$nameimg";

  //                     ref =
  //                         FirebaseStorage.instance.ref("images").child(nameimg);
  //                     Navigator.of(context).pop();
  //                   }
  //                 },
  //                 child: Container(
  //                   padding: const EdgeInsets.all(10),
  //                   width: double.infinity,
  //                   child: Row(
  //                     children: const [
  //                       Icon(
  //                         Icons.camera,
  //                         size: 30,
  //                       ),
  //                       SizedBox(
  //                         height: 20,
  //                       ),
  //                       Text("From Camera"),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         );
  //       });
  // }
}
