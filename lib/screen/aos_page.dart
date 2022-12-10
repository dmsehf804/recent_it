import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recent_it/model/question_list_model.dart';
import 'package:recent_it/screen/markdown_display_page.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AOSPage extends StatefulWidget {
  const AOSPage({super.key});

  @override
  State<AOSPage> createState() => _AOSPage();
}

class _AOSPage extends State<AOSPage> {
  final String _markDownPath = 'assets/markdown/AOS';
  late List<String> _ContentList = [];
  late List<String> _FullPath = [];

  @override
  void initState() {
    super.initState();
    _getQuestionList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _getQuestionList() async {
    final storageRef = FirebaseStorage.instance.ref().child('android');
    final listResult = await storageRef.listAll();
    List<String> contentList = [];
    List<String> pathList = [];
    for (var items in listResult.items) {
      print(items.fullPath.split('/').last);
      contentList.add(items.fullPath.split('/').last.split('.').first);
      pathList.add(items.fullPath);
    }
    setState(() {
      _ContentList = contentList;
      _FullPath = pathList;
    });
  }

  // Future<void> _getQuestionList() async {
  //   CollectionReference<Map<String, dynamic>> collectionReference =
  //       FirebaseFirestore.instance.collection('android');
  //   QuerySnapshot<Map<String, dynamic>> querySnapshot =
  //       await collectionReference.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData);
  //   List<String> qList = [];
  //   List<String> aList = [];
  //   allData.forEach((data) => data.forEach((key, value) {
  //         if (key == 'q') {
  //           qList.add(value);
  //         }
  //         if (key == 'a') {
  //           aList.add(value);
  //         }
  //       }));
  //   setState(() {
  //     _QuestionList = qList;
  //     _AnswerList = aList;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _ContentList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => MarkdownDisplayPage(
                            question: _ContentList[index],
                            fullpath: _FullPath[index]))));
              },
              title: Text('${_ContentList[index]}'),
            ),
          );
        },
      ),
    );
  }
}
