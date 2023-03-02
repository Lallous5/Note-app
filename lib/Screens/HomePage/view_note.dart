import 'package:flutter/material.dart';
import 'package:masteringflutterwithfirebase/constants.dart';

class ViewNotes extends StatefulWidget {
  ViewNotes({Key? key, this.notes, this.colors}) : super(key: key);
  final notes;
  final colors;
  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.colors,
      appBar: AppBar(
        backgroundColor: widget.colors,
        title: const Text("View notes"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              "${widget.notes['title']}",
              style: TextStyle(
                fontSize: 35,
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
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
