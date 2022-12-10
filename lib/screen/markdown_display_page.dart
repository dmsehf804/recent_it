import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: must_be_immutable
class MarkdownDisplayPage extends StatefulWidget {
  String fullpath;
  String question;
  List<String> pathlist;
  int currentindex;
  MarkdownDisplayPage(
      {Key? key,
      required this.question,
      required this.fullpath,
      required this.pathlist,
      required this.currentindex})
      : super(key: key);

  @override
  State<MarkdownDisplayPage> createState() =>
      // ignore: no_logic_in_create_state
      _MarkdownDisplayPage(question, fullpath, pathlist, currentindex);
}

enum TtsState { playing, stopped, paused, continued }

class _MarkdownDisplayPage extends State<MarkdownDisplayPage> {
  String fullpath;
  final String question;
  late String filepath = '';
  late String markDownData = '';
  late String ttsStringData = '';
  List<String> pathlist = [];
  double strong_size = 1.0;
  double p_size = 20.0;
  int currentindex = 0;
  double pitch = 1.0;
  double rate = 0.5;
  double volume = 0.5;
  FlutterTts flutterTts = FlutterTts();

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  var autonextpageflag = true;
  var _color = Colors.red;
  _MarkdownDisplayPage(
      this.question, this.fullpath, this.pathlist, this.currentindex);

  @override
  void initState() {
    super.initState();
    flutterTts.setVolume(volume);
    flutterTts.setSpeechRate(rate);
    flutterTts.setPitch(pitch);
    _getMarkDownData(fullpath);
    initTts();
  }

  initTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
        if (autonextpageflag) {
          if (currentindex < pathlist.length) {
            currentindex += 1;
          }
          print("Complete");
          _getMarkDownData(pathlist[currentindex]);
          print("Complete");
        }
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS || isWindows) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage('ko');
    await flutterTts.setEngine('com.samsung.SMT');

    if (ttsStringData.isNotEmpty) {
      await flutterTts.speak(ttsStringData);
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  Future<void> _getMarkDownData(inputfullpath) async {
    final storageRef = FirebaseStorage.instance.ref();
    final islandRef = storageRef.child(inputfullpath);

    try {
      const oneMegabyte = 1024 * 1024;
      final Uint8List? data = await islandRef.getData(oneMegabyte);
      print(data);
      setState(() {
        markDownData = const Utf8Decoder().convert(data!);
        ttsStringData = markDownData.replaceAll('*', '');
      });

      print(markDownData);
      // Data for "images/island.jpg" is returned, use this as needed.
    } on FirebaseException catch (e) {
      // Handle any errors.
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(question),
        // ignore: prefer_const_constructors
        titleTextStyle: const TextStyle(
            fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
                height: 500.0,
                margin: const EdgeInsets.all(20.0),
                child: Markdown(
                  data: markDownData,
                  styleSheet: MarkdownStyleSheet(
                    textScaleFactor: strong_size,
                    strong: const TextStyle(
                        fontSize: 24.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        height: 2.0),
                    p: const TextStyle(
                        fontSize: 20.0, color: Colors.black, height: 2.0),
                  ),
                )),
            Row(
              children: [
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        _speak();
                        print('asdsad');
                      },
                      child: const Icon(Icons.play_arrow)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        _stop();
                      },
                      child: const Icon(Icons.stop)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (currentindex != 0) {
                            currentindex -= 1;
                          }
                          _getMarkDownData(pathlist[currentindex]);
                        });
                      },
                      child: const Icon(Icons.arrow_back)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (currentindex < pathlist.length) {
                            currentindex += 1;
                          }
                          _getMarkDownData(pathlist[currentindex]);
                        });
                      },
                      child: const Icon(Icons.arrow_forward)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (autonextpageflag) {
                            _color = Colors.blue;
                            autonextpageflag = false;
                          } else {
                            _color = Colors.red;
                            autonextpageflag = true;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(primary: _color),
                      child: const Icon(Icons.auto_mode)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          strong_size += 0.1;
                        });
                      },
                      child: const Icon(Icons.add)),
                ),
                SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          strong_size -= 0.1;
                        });
                      },
                      child: const Icon(Icons.remove)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
