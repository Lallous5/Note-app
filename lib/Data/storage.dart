//  late File file;
//   var imagepicker = ImagePicker();
//   uploadImage() async {
//     var imagepicked = await imagepicker.pickImage(source: ImageSource.camera);
//     if (imagepicked != null) {
//       var nameimage = basename(imagepicked.path);
//       file = File(imagepicked.path);
//       // print("======================================");
//       // print(nameimage);
//       // print("======================================");
//       // print(imagepicked.path);
//       // print("======================================");
//       // Start upload
//       var randomId = Random().nextInt(999999);

//       nameimage = "$randomId$nameimage";

//       var refStg = FirebaseStorage.instance.ref("avatar").child(nameimage);
//       try {
//         await refStg.putFile(file);
//       } catch (e) {
//         print("errrorrrrr $e");
//       }

//       // var url = await refStg.getDownloadURL();
//       // print("======================================");
//       // print("urllll : $url");
//       // print("======================================");
//     } else {
//       print("please choose a picture");
//     }
//   }

//   getImagesName() async {
//     var ref = await FirebaseStorage.instance.ref().list();
//     ref.items.forEach((element) {
//       print("*-*-*-*-*-*-*-*-*-*-*-*-*-/*/-*/-*/*-/-*");
//       print(element.name);
//       print("*-*-*-*-*-*-*-*-*-*-*-*-*-/*/-*/-*/*-/-*");
//     });
//   }