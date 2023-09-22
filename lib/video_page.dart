import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  bool isLoading = false;
  bool isPlay = false;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _initVideoPlayer();

    super.initState();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(false);
    await _videoPlayerController.play();
    setState(() {
      isPlay = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: const Text('Preview'),
      //   elevation: 0,
      //   backgroundColor: Colors.black26,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.check),
      //       onPressed: () {
      //         Navigator.pop(context, File(widget.filePath));
      //       },
      //     ),
      //   ],
      // ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            _videoPlayerController.value.isInitialized
                ? VideoPlayer(_videoPlayerController)
                : const Center(child: CircularProgressIndicator()),
            // FutureBuilder(
            //   future: _initVideoPlayer(),
            //   builder: (context, state) {
            //     if (state.connectionState == ConnectionState.waiting) {
            //       return const Center(child: CircularProgressIndicator());
            //     } else {
            //       return VideoPlayer(_videoPlayerController);
            //     }
            //   },
            // ),
            Positioned(
                bottom: 30,
                right: 20,
                child: Column(
                  children: [
                    isLoading == false
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                              });
                              GallerySaver.saveVideo(widget.filePath,
                                      albumName: "CardCarfters/Videos",
                                      toDcim: true)
                                  .then((bool? success) {
                                if (success == true) {
                                  showFluttertoast(
                                      "Video Download Successfully");
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              });
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 30,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(height: 15),
                    IconButton(
                      onPressed: () async {
                        await Share.shareFiles([widget.filePath],
                            text: "Please watch this video");
                      },
                      icon: const Icon(
                        FontAwesomeIcons.share,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                //
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFC5C5CA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.check,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (_videoPlayerController.value.isPlaying == true) {
                  isPlay = false;
                  await _videoPlayerController.pause();
                } else {
                  isPlay = true;
                  await _videoPlayerController.play();
                }
                setState(() {});
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPlay == true
                      ? FontAwesomeIcons.pause
                      : FontAwesomeIcons.play,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                bottomSheet(context, size.height, size.width);
              },
              child: Container(
                height: 50,
                width: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFC5C5CA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  FontAwesomeIcons.close,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showFluttertoast(String text) {
    return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: const Color(0xFFC5C5CA),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  bottomSheet(BuildContext context, double hSize, double wSize) {
    return showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 250,
          // padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20))),
          child: SingleChildScrollView(
              child: Container(
            height: 250,
            // height: hSize * .3,
            // width: wSize,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(width: 2, color: Colors.white),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white,
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(2, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Are you sure you want to back?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context, File(widget.filePath));
                      },
                      child: Container(
                        // height: 30,
                        width: wSize * .25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        // height: 30,
                        width: wSize * .25,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Text(
                          "No",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
        );
      },
    );
  }
}
