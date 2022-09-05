import 'package:flutter/material.dart';
import 'package:masteringflutterwithfirebase/constants.dart';

class ViewNotes extends StatefulWidget {
  ViewNotes({Key? key, this.notes}) : super(key: key);
  final notes;

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View notes"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Image.network(
            "${widget.notes['image']}",
            width: double.infinity,
            height: 300,
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${widget.notes['title']}",
            style: TextStyle(
              fontSize: 22,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${widget.notes['body']}",
              style: TextStyle(
                fontSize: 22,
                color: kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
