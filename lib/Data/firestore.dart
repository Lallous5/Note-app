// ignore_for_file: unused_local_variable, avoid_print



///////////////////////ADDDATA/////////////////////////////////////////////////
// addData() async {
//     CollectionReference usersRef =
//         FirebaseFirestore.instance.collection("users");

//     usersRef.add({
//       "username": "eliane",
//       "age": "20",
//       "email": "eliane@gmail.com",
//     });
//     usersRef.doc("12lelo12").set({
//         "username": "nancy",
//       "age": "22",
//       "email": "nancy@gmail.com",
//     });
//   }
  //////////////////////GETDATA//////////////////////////////////////////
  // getData() async {
  //   var docs = FirebaseFirestore.instance
  //       .collection("users")
  //       .doc("vncRJPbuTRu1onwE3iPm")
  //       .get()
  //       .then((value) {
  //     print(value.data());
  //   });
  // }

  ////////////////////////// GETARRAYDATA/////////////////////////////////////////
  // getarrayData() async {
  //   CollectionReference usersRef =
  //       FirebaseFirestore.instance.collection("users");
  //   await usersRef.where("lang", arrayContains: "arabic").get().then((value) {
  //     for (var element in value.docs) {
  //       print(element.data());
  //     }
  //   });
  // }


/////////////////////UPDATE//////////////////////////////////////////


  // updateData() async {
  //   CollectionReference usersRef =
  //       FirebaseFirestore.instance.collection("users");
  //   usersRef.doc("12lelo12").update({
  //     "username": "lounii",
  //   });
  // }

  /////////////////////////DELETE////////////////////////////////
  
  // deleteData() async {
  //   CollectionReference usersRef =
  //       FirebaseFirestore.instance.collection("users");
  //   usersRef.doc("12lelo12").delete().then((value) {
  //     print("object");
  //   }).catchError((e) {
  //     print("error $e");
  //   });
  // }


/////////////////////////////////////////////////////



  // getcollectionData() async {
  //   CollectionReference addresssRef = FirebaseFirestore.instance
  //       .collection("users")
  //       .doc("SvAn695cENnlgpdEfYfj")
  //       .collection("address");

  //   addresssRef.doc("7TFiFQ9eJhGsv8SsVWpY").update({
  //     "city": "miniara",
  //   });
  // }


////////////////////////BATCH SET UPDATE IN THE SAME TIME///////////////////////////

  // DocumentReference docone = FirebaseFirestore.instance
  //     .collection("users")
  //     .doc("3wpzYOmJQMs40ysQ9el4");
  // DocumentReference doctwo = FirebaseFirestore.instance
  //     .collection("users")
  //     .doc("SvAn695cENnlgpdEfYfj");

  // batchWrite() async {
  //   WriteBatch batch = FirebaseFirestore.instance.batch();
  //   batch.delete(docone);
  //   batch.update(doctwo, {"age": "22"});
  //   batch.commit();
  // }


////////////////////////////DATABASE//////////////////////////////


// List users = [];
//   CollectionReference usersRef = FirebaseFirestore.instance.collection("users");

//   getDate() async {
//     var response = await usersRef.get();
//     response.docs.forEach((element) {
//       setState(() {
//         users.add(element.data());
//       });
//       print(users);
//     });
//   }
//    FutureBuilder(
//         future: usersRef.get(),
//         builder: ((context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Text(users[index]['age']),
//                   title: Text(users[index]['username']),
//                   subtitle: Text(users[index]['email']),
//                   trailing: Icon(Icons.phone),
//                 );
//               },
//             );
//           }
//           if (snapshot.hasError) {
//             return Text("error");
//           }

//           return CircularProgressIndicator();
//         }),
//       ),




///////////////////REALTIME DATABASE/////////////////////////////////////




  // final Stream<QuerySnapshot> _usersStream =
  //     FirebaseFirestore.instance.collection('note').snapshots();

// StreamBuilder<QuerySnapshot>(
//           stream: _usersStream,
//           builder:
//               (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//             if (snapshot.hasError) {
//               return Text('Something went wrong');
//             }

//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Text("Loading");
//             }

            // return ListView(
            //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
            //     Map<String, dynamic> data =
            //         document.data()! as Map<String, dynamic>;
            //     return ListTile(
            //       title: Text(
            //         data['title'],
            //         style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            //       ),
            //       subtitle: Text(data['body'],
            //           style: TextStyle(
            //               fontSize: 18, fontWeight: FontWeight.normal)),
            //     );
            //   }).toList(),
            // );
//           },
//         )