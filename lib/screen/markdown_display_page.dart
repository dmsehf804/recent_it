// ignore_for_file: unnecessary_this

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';

class MarkdownDisplayPage extends StatefulWidget {
  String fullpath;
  String question;

  MarkdownDisplayPage(
      {Key? key, required this.question, required this.fullpath})
      : super(key: key);

  @override
  State<MarkdownDisplayPage> createState() =>
      _MarkdownDisplayPage(question, fullpath);
}

class _MarkdownDisplayPage extends State<MarkdownDisplayPage> {
  String fullpath;
  final String question;
  late String filepath = '';
  _MarkdownDisplayPage(this.question, this.fullpath);

  @override
  void initState() {
    super.initState();
    _getMarkDownData();
  }

  Future<void> _getMarkDownData() async {
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child(fullpath);

    final appDocDir = await getApplicationDocumentsDirectory();
    final rootfilePath = "${appDocDir.absolute}/";
    // .replaceAll("'", '')
    // .replaceAll('Directory: ', '');
    final filePath = rootfilePath + fullpath;
    print(filePath);

    setState(() {
      filepath = filePath;
    });

    final file = File(filePath);

    final downloadTask = islandRef.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          print('Download running');
          break;
        case TaskState.paused:
          // TODO: Handle this case.
          break;
        case TaskState.success:
          // TODO: Handle this case.
          print('Download success');
          break;
        case TaskState.canceled:
          // TODO: Handle this case.
          print('cancel');
          break;
        case TaskState.error:
          // TODO: Handle this case.
          print('download error');
          break;
      }
    });

    var read_string = await file.readAsString();
    print(read_string);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(question),
        // ignore: prefer_const_constructors
        titleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: FutureBuilder(
              future: rootBundle.loadString(filepath),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Markdown(
                    data: snapshot.data ?? "",
                    styleSheet: MarkdownStyleSheet(
                      h1: TextStyle(
                          fontSize: 24,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }
                print('asdasdasd');
                print(filepath);
                return Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ),
      ),
    );
  }
}
