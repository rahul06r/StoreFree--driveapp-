import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class NextScreen extends StatefulWidget {
  final String name;
  final bool ispdf;
  final bool ismp4;
  final bool isImage;
  final bool isZip;
  final String image;
  const NextScreen({
    super.key,
    required this.image,
    required this.ispdf,
    required this.ismp4,
    required this.isImage,
    required this.isZip,
    required this.name,
  });

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late VideoPlayerController _controller;
  bool isloadig = false;

  void downloadFunctionforIVP() async {
    Dio dio = Dio();

    final Response response = await dio.get(widget.image,
        options: Options(responseType: ResponseType.bytes));

    final savePath = await getExternalStorageDirectory();
    File file = File(savePath!.path + widget.name);
    file.writeAsBytesSync(await response.data);
    Fluttertoast.showToast(
      msg: "Downloaded Successfully",
      backgroundColor: Pallete.greenColor,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      fontSize: 20,
    );
  }

  @override
  void initState() {
    super.initState();
    print("${widget.image}  iniststate");
    if (widget.ismp4) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.image))
        ..initialize().then((value) {
          _controller.setLooping(true);
          _controller.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Pallete.blackColor),
          automaticallyImplyLeading: true,
          backgroundColor: Pallete.yellowColor,
          title: Text(
            widget.name,
            style: TextStyle(
              color: Pallete.blackColor,
            ),
          ),
          actions: [
            // !widget.ismp4
            //     ?
            widget.isZip
                ? Container()
                : IconButton(
                    onPressed: () async {
                      print(
                          "Download ${widget.image.split("?")[0].toString()}");
                      print("Download Actual ${widget.image}");
                      try {
                        // some error in download patch of MP4

                        if (widget.ispdf || widget.isImage) {
                          downloadFunctionforIVP();
                        } else {
                          // child:
                          showDialog(
                              context: context,
                              builder: (context) {
                                return DownloadWidget(widget: widget);
                              });

                          Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              msg:
                                  "Video cannot be downloaded for now,the feature will roll out soon!!",
                              backgroundColor: Pallete.redColor);
                          print("MP4 still not discovered");
                        }
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    icon: Icon(
                      Icons.download_rounded,
                    ))
            // : Container(),
          ],
        ),
        body: Container(
            child: (widget.ispdf)
                ? PDF().cachedFromUrl(
                    widget.image,
                    placeholder: (progress) => Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Pallete.blackColor,
                      valueColor: AlwaysStoppedAnimation(Pallete.yellowColor),
                    )),
                    errorWidget: (error) =>
                        Center(child: Text(error.toString())),
                  )
                : (widget.ismp4)
                    ? _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(
                              _controller,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          )
                    : (widget.isZip)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "Cannot show the deatils of zip !!",
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                              SizedBox(height: 15),
                              IconButton(
                                  onPressed: () {
                                    showDialog(
                                        useSafeArea: true,
                                        context: context,
                                        builder: (context) {
                                          return DownloadWidget(widget: widget);
                                        });
                                  },
                                  icon: Icon(
                                    Icons.download_for_offline,
                                    size: 50,
                                    color: Pallete.yellowColor,
                                  ))
                            ],
                          )
                        : InstaImageViewer(
                            backgroundIsTransparent: true,
                            disableSwipeToDismiss: true,
                            disposeLevel: DisposeLevel.high,
                            child: CachedNetworkImage(
                              imageUrl: widget.image,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   "Cannot open !! right now!",
                                    //   style: TextStyle(color: Pallete.whiteColor),
                                    // ),
                                    Icon(
                                      Icons.error,
                                      color: Pallete.whiteColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )));
  }
}

class DownloadWidget extends StatelessWidget {
  const DownloadWidget({
    super.key,
    required this.widget,
  });

  final NextScreen widget;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Pallete.yellowColor,
      title: Center(
        child: Text(
          "Copy the Link",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.image,
                  maxLines: 1,
                  //  textScaler: ,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
            IconButton(
                onPressed: () {
                  FlutterClipboard.copy(widget.image).then((value) {
                    Fluttertoast.showToast(
                        msg: "Link Copied",
                        backgroundColor: Pallete.greenColor);
                  });
                },
                icon: Icon(
                  Icons.copy,
                  color: Pallete.blackColor,
                  size: 25,
                )),
          ],
        ),
        Center(
          child: Text(
            "to download 😄 😄",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )
      ],
    );
  }
}
