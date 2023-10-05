import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:video_player/video_player.dart';

class NextScreen extends StatefulWidget {
  final bool ispdf;
  final bool ismp4;
  final bool isImage;
  final String image;
  const NextScreen({
    super.key,
    required this.image,
    required this.ispdf,
    required this.ismp4,
    required this.isImage,
  });

  @override
  State<NextScreen> createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
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
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ispdf) {
      return FutureBuilder(
          future: PDFDocument.fromURL(widget.image),
          builder: (context, snapshot) {
            if (snapshot.hasError || snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return PDFViewer(
              document: snapshot.data!,
            );
          });
    } else if (widget.ismp4) {
      return _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(
                _controller,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            );
    } else {
      return InstaImageViewer(
        backgroundIsTransparent: true,
        disableSwipeToDismiss: true,
        disposeLevel: DisposeLevel.high,
        child: Image(image: Image.network(widget.image).image),
      );
    }
  }
}
