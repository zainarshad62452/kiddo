import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as ui;


class JigsawPuzzle extends StatefulWidget {
  const JigsawPuzzle({
    Key? key,
    required this.gridSize,
    required this.image,
    required this.puzzleKey,
    this.onFinished,
    this.onBlockSuccess,
    this.outlineCanvas = true,
    this.autoStart = false,
    this.snapSensitivity = .5,
    this.onTap,
    required this.level
  }) : super(key: key);

  final int gridSize;
  final Function()? onFinished;
  final Function()? onBlockSuccess;
  final Function()? onTap;
  final AssetImage image;
  final String level;
  final bool autoStart;
  final bool outlineCanvas;
  final double snapSensitivity;
  final GlobalKey<JigsawWidgetState> puzzleKey;

  @override
  _JigsawPuzzleState createState() => _JigsawPuzzleState();
}

class _JigsawPuzzleState extends State<JigsawPuzzle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        JigsawWidget(
          onTap: widget.onTap,
          callbackFinish: () {
            if (widget.onFinished != null) {
              widget.onFinished!();
            }
          },
          callbackSuccess: () {
            if (widget.onBlockSuccess != null) {
              widget.onBlockSuccess!();
            }

          },
          key: widget.puzzleKey,
          gridSize: widget.gridSize,
          snapSensitivity: widget.snapSensitivity,
          outlineCanvas: widget.outlineCanvas,
          level: widget.level,
          child: Image(
            fit: BoxFit.contain,
            image: widget.image,
          ),
        ),
      ],
    );
  }
}

class JigsawWidget extends StatefulWidget {
  const JigsawWidget({
    Key? key,
    required this.gridSize,
    required this.snapSensitivity,
    required this.child,
    this.callbackFinish,
    this.callbackSuccess,
    this.onTap,
    required this.level,
    this.outlineCanvas = true,
  }) : super(key: key);

  final Widget child;
  final Function()? callbackSuccess;
  final Function()? callbackFinish;
  final Function()? onTap;
  final int gridSize;
  final String level;
  final bool outlineCanvas;
  final double snapSensitivity;

  @override
  JigsawWidgetState createState() => JigsawWidgetState();
}

class JigsawWidgetState extends State<JigsawWidget> {
  final GlobalKey _globalKey = GlobalKey();
  ui.Image? fullImage;
  Size? size;

  List<List<BlockClass>> images = <List<BlockClass>>[];
  ValueNotifier<List<BlockClass>> blocksNotifier =
  ValueNotifier<List<BlockClass>>(<BlockClass>[]);
  CarouselController? _carouselController;

  Offset _pos = Offset.zero;
  int? _index;

  Future<ui.Image?> _getImageFromWidget() async {
    final RenderRepaintBoundary boundary =
    _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;

    size = boundary.size;
    final img = await boundary.toImage();
    final byteData = await img.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (pngBytes == null) {
      throw InvalidImageException();
    }
    Uint8List pngData = Uint8List.fromList(pngBytes);
    return ui.decodeImage(pngData);
  }

  void reset() {
    images.clear();
    blocksNotifier = ValueNotifier<List<BlockClass>>(<BlockClass>[]);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  Future<void> generate() async {
    images = [[]];

    fullImage ??= await _getImageFromWidget();

    final int xSplitCount = widget.gridSize;
    final int ySplitCount = widget.gridSize;

    final double widthPerBlock = fullImage!.width / xSplitCount;
    final double heightPerBlock = fullImage!.height / ySplitCount;

    for (var y = 0; y < ySplitCount; y++) {
      final tempImages = <BlockClass>[];

      images.add(tempImages);
      // final value1 = math.Random().nextInt(1);
      // final value2 = math.Random().nextInt(3);
      for (var x = 0; x < xSplitCount; x++) {
        final int randomPosRow = math.Random().nextInt(2).isEven ? 1 : -1;
        final int randomPosCol = math.Random().nextInt(2).isEven ? 1 : -1;

        Offset offsetCenter = Offset(widthPerBlock / 2, heightPerBlock / 2);

        final ClassJigsawPos jigsawPosSide = ClassJigsawPos(
          bottom: y == ySplitCount - 1 ? 0 : randomPosCol,
          left: x == 0
              ? 0
              : -images[y][x - 1].jigsawBlockWidget.imageBox.posSide.right,
          right: x == xSplitCount - 1 ? 0 : randomPosRow,
          top: y == 0
              ? 0
              : -images[y - 1][x].jigsawBlockWidget.imageBox.posSide.bottom,
        );
        double xAxis = widthPerBlock * x;
        double yAxis = heightPerBlock * y;

        final double minSize = math.min(widthPerBlock, heightPerBlock) / 15 * 4;

        offsetCenter = Offset(
          (widthPerBlock / 2) + (jigsawPosSide.left == 1 ? minSize : 0),
          (heightPerBlock / 2) + (jigsawPosSide.top == 1 ? minSize : 0),
        );

        xAxis -= jigsawPosSide.left == 1 ? minSize : 0;
        yAxis -= jigsawPosSide.top == 1 ? minSize : 0;

        final double widthPerBlockTemp = widthPerBlock +
            (jigsawPosSide.left == 1 ? minSize : 0) +
            (jigsawPosSide.right == 1 ? minSize : 0);
        final double heightPerBlockTemp = heightPerBlock +
            (jigsawPosSide.top == 1 ? minSize : 0) +
            (jigsawPosSide.bottom == 1 ? minSize : 0);

        final ui.Image temp = ui.copyCrop(
          fullImage!,
          x:xAxis.round(),
          y:yAxis.round(),
          width:widthPerBlockTemp.round(),
          height:heightPerBlockTemp.round(),
        );

        final Offset offset = Offset(size!.width / 2 - widthPerBlockTemp / 2,
            size!.height / 2 - heightPerBlockTemp / 2);
/// Here the sounds initializes
        final ImageBox imageBox = ImageBox(
          image: Image.memory(
            Uint8List.fromList(ui.encodePng(temp)),
            fit: BoxFit.contain,
          ),
          isDone: false,
          offsetCenter: offsetCenter,
          posSide: jigsawPosSide,
          radiusPoint: minSize,
          size: Size(widthPerBlockTemp, heightPerBlockTemp), soundFile: getSound(x, y, widget.gridSize,true),text: getSound(x, y, widget.gridSize,false),
        );

        images[y].add(
          BlockClass(
              jigsawBlockWidget: JigsawBlockWidget(
                imageBox: imageBox,
              ),
              offset: offset,
              offsetDefault: Offset(xAxis, yAxis)),
        );
        // if(value1==y && value2==x){
        //   images[y][x].jigsawBlockWidget.imageBox.isDone = true;
        // }
      }
    }

    // for(int y = 0;y<4;y++){
    //   final value1 = math.Random().nextInt(3);
    //   final value2 = math.Random().nextInt(3);
    //   print(value1);
    //   print(value2);
    //   images[value1][value2].jigsawBlockWidget.imageBox.isDone = true;
    // }
    blocksNotifier.value = images.expand((image) => image).toList();
    blocksNotifier.value.shuffle();
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    blocksNotifier.notifyListeners();
    setState(() {});
  }

  String getSound(int x,int y,int gridSize,bool isSound){
    String sound = "";
    String text = "";
    if(widget.level == "level2"){
      if(y==0 && x==0){
        sound = "partsofbody2/pancreas.mp3";
        text = "Pancreas";
      }else if(y==0 && x==1){
        sound = "partsofbody2/brain.mp3";
        text = "Brain";
      }else if(y==0 && x==2){
        sound = "partsofbody2/lungs.mp3";
        text = "Lungs";
      }else if(y==1 && x==0){
        sound = "partsofbody2/liver.mp3";
        text = "Liver";
      }else if(y==1 && x==1){
        sound = "partsofbody2/heart.mp3";
        text = "Heart";
      }else if(y==1 && x==2){
        sound = "partsofbody2/spleen.mp3";
        text = "Spleen";
      }else if(y==2 && x==0){
        sound = "partsofbody2/tooth.mp3";
        text = "Tooth";
      }else if(y==2 && x==1){
        sound = "partsofbody2/kidneys.mp3";
        text = "Kidneys";
      }else if(y==2 && x==2){
        sound = "partsofbody2/stomach.mp3";
        text = "Stomach";
      }
      if(isSound){
        return sound;
      }else{
        return text;
      }
    }else if(widget.level=="level1"){
      if(y==0 && x==0){
        sound = "partsofbody/hand.mp3";
        text = "Hand";
      }else if(y==0 && x==1){
        sound = "partsofbody/foot.mp3";
        text = "Foot";
      }else if(y==0 && x==2){
        sound = "partsofbody/arm.mp3";
        text = "Arm";
      }else if(y==1 && x==0){
        sound = "partsofbody/mouth.mp3";
        text = "Mouth";
      }else if(y==1 && x==1){
        sound = "partsofbody/body.mp3";
        text = "Body";
      }else if(y==1 && x==2){
        sound = "partsofbody/eye.mp3";
        text = "Eye";
      }else if(y==2 && x==0){
        sound = "partsofbody/leg.mp3";
        text = "Leg";
      }else if(y==2 && x==1){
        sound = "partsofbody/ear.mp3";
        text = "Ear";
      }else if(y==2 && x==2){
        sound = "partsofbody/nose.mp3";
        text = "Nose";
      }
      if(isSound){
        return sound;
      }else{
        return text;
      }
    }

    if(isSound){
      return sound;
    }else{
      return text;
    }
  }

  @override
  void initState() {
    _carouselController = CarouselController();
    super.initState();
  }
  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: blocksNotifier,
        builder: (context, List<BlockClass> blocks, child) {
          final List<BlockClass> blockNotDone = blocks
              .where((block) => !block.jigsawBlockWidget.imageBox.isDone)
              .toList();
          final List<BlockClass> blockDone = blocks
              .where((block) => block.jigsawBlockWidget.imageBox.isDone)
              .toList();

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: SizedBox(
                  width: double.infinity,
                  child: Listener(
                    onPointerUp: (event) {
                      if (blockNotDone.isEmpty) {
                        reset();
                        widget.callbackFinish?.call();
                      }

                      if (_index == null) {
                        _carouselController?.nextPage(
                            duration: const Duration(microseconds: 600));
                        setState(() {});
                      }
                    },
                    onPointerMove: (event) {
                      if (_index == null) {
                        return;
                      }
                      if (blockNotDone.isEmpty) {
                        return;
                      }

                      final Offset offset = event.localPosition - _pos;

                      blockNotDone[_index!].offset = offset;

                      const minSensitivity = 0;
                      const maxSensitivity = 1;
                      const maxDistanceThreshold = 20;
                      const minDistanceThreshold = 1;

                      final sensitivity = widget.snapSensitivity;
                      final distanceThreshold = sensitivity *
                          (maxSensitivity - minSensitivity) *
                          (maxDistanceThreshold - minDistanceThreshold) +
                          minDistanceThreshold;

                      if ((blockNotDone[_index!].offset -
                          blockNotDone[_index!].offsetDefault)
                          .distance <
                          distanceThreshold) {
                        blockNotDone[_index!]
                            .jigsawBlockWidget
                            .imageBox
                            .isDone = true;

                        blockNotDone[_index!].offset =
                            blockNotDone[_index!].offsetDefault;

                        _index = null;

                        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                        blocksNotifier.notifyListeners();

                        widget.callbackSuccess?.call();
                      }

                      setState(() {});
                    },
                    child: Stack(
                      children: [
                        if (blocks.isEmpty) ...[
                          RepaintBoundary(
                            key: _globalKey,
                            child: SizedBox(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: widget.child,
                            ),
                          )
                        ],
                        Offstage(
                          offstage: blocks.isEmpty,
                          child: Container(
                            color: Colors.white,
                            width: size?.width,
                            height: size?.height,
                            child: CustomPaint(
                              painter: JigsawPainterBackground(
                                blocks,
                                outlineCanvas: widget.outlineCanvas,
                              ),
                              child: Stack(
                                children: [
                                  if (blockDone.isNotEmpty)
                                    ...blockDone.map(
                                          (map) {
                                        return Positioned(
                                          left: map.offset.dx,
                                          top: map.offset.dy,
                                          child: Container(
                                            child: map.jigsawBlockWidget,
                                          ),
                                        );
                                      },
                                    ),
                                  if (blockNotDone.isNotEmpty)
                                    ...blockNotDone.asMap().entries.map(
                                          (map) {
                                        return Positioned(
                                          left: map.value.offset.dx,
                                          top: map.value.offset.dy,
                                          child: Offstage(
                                            offstage: !(_index == map.key),
                                            child: GestureDetector(
                                              onTapDown: (details) {
                                                if (map.value.jigsawBlockWidget
                                                    .imageBox.isDone) {
                                                  return;
                                                }

                                                setState(() {
                                                  _pos = details.localPosition;
                                                  _index = map.key;
                                                });
                                              },
                                              /// This is place to add body parts voice
                                              child: GestureDetector(
                                                onTap: (){
                                                  player.play(AssetSource(map.value.jigsawBlockWidget.imageBox.soundFile));
                                                },
                                                child:
                                                Column(
                                                  children: [
                                                    Container(
                                                      child:
                                                      map.value.jigsawBlockWidget,
                                                    ),
                                                    // SizedBox(height: 10.0,),
                                                    // Container(
                                                    //     decoration: BoxDecoration(
                                                    //       border: Border.all(color: Colors.black,width: 1.5),
                                                    //       borderRadius: BorderRadius.circular(5.0),
                                                    //     ),
                                                    //     child: Padding(
                                                    //   padding: const EdgeInsets.all(8.0),
                                                    //   child: Center(child: Text(map.value.jigsawBlockWidget.imageBox.text,style: TextStyle(fontSize: 30.0),)),
                                                    // )),
                                                  ],
                                                ),

                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  color: Colors.white,
                  height: 120,
                  child: CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      initialPage: _index ?? 0,
                      height: 80,
                      aspectRatio: 1,
                      viewportFraction: 0.3,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        player.play(AssetSource(blockNotDone[index].jigsawBlockWidget.imageBox.soundFile));
                        _index = index;
                        setState(() {});
                      },
                    ),
                    items: blockNotDone.map((block) {
                      final Size sizeBlock =
                          block.jigsawBlockWidget.imageBox.size;
                      ///This is place to get voice
                      return GestureDetector(
                        child: FittedBox(
                          child: SizedBox(
                            width: sizeBlock.width,
                            height: sizeBlock.height,
                            child: block.jigsawBlockWidget,
                          ),
                        ),
                      );
                    }).toList(),
                  ))
            ],
          );
        });
  }
}

class JigsawPainterBackground extends CustomPainter {
  JigsawPainterBackground(this.blocks, {required this.outlineCanvas});

  List<BlockClass> blocks;
  bool outlineCanvas;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = outlineCanvas ? PaintingStyle.stroke : PaintingStyle.fill
      ..color = Colors.black12
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final Path path = Path();

    blocks.forEach((element) {
      final Path pathTemp = getPiecePath(
        element.jigsawBlockWidget.imageBox.size,
        element.jigsawBlockWidget.imageBox.radiusPoint,
        element.jigsawBlockWidget.imageBox.offsetCenter,
        element.jigsawBlockWidget.imageBox.posSide,
      );

      path.addPath(pathTemp, element.offsetDefault);
    });

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class BlockClass {
  BlockClass({
    required this.offset,
    required this.jigsawBlockWidget,
    required this.offsetDefault,
  });

  Offset offset;
  Offset offsetDefault;
  JigsawBlockWidget jigsawBlockWidget;
}

class ImageBox {

  ImageBox({
    required this.image,
    required this.posSide,
    required this.isDone,
    required this.offsetCenter,
    required this.radiusPoint,
    required this.size,
    required this.soundFile,
    required this.text,
  });

  Widget image;
  ClassJigsawPos posSide;
  Offset offsetCenter;
  Size size;
  double radiusPoint;
  bool isDone;
  final String soundFile;
  String text;
}

class ClassJigsawPos {
  ClassJigsawPos({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });

  int top, bottom, left, right;
}

class JigsawBlockWidget extends StatefulWidget {
  const JigsawBlockWidget({Key? key, required this.imageBox}) : super(key: key);

  final ImageBox imageBox;

  @override
  _JigsawBlockWidgetState createState() => _JigsawBlockWidgetState();
}

class _JigsawBlockWidgetState extends State<JigsawBlockWidget> {
  final player = AudioPlayer();
  /// On Tap for sound on piece
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(widget.imageBox.soundFile!="")
        player.play(AssetSource(widget.imageBox.soundFile));
      },
      child: ClipPath(
        clipper: PuzzlePieceClipper(imageBox: widget.imageBox),
        child: CustomPaint(
          foregroundPainter: JigsawBlokPainter(imageBox: widget.imageBox),
          child: widget.imageBox.image,
        ),
      ),
    );
  }
}

class JigsawBlokPainter extends CustomPainter {
  JigsawBlokPainter({
    required this.imageBox,
  });

  ImageBox imageBox;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = imageBox.isDone ? Colors.black.withOpacity(0.2) : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(
        getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
            imageBox.posSide),
        paint);

    if (imageBox.isDone) {
      final Paint paintDone = Paint()
        ..color = Colors.white.withOpacity(0.2)
        ..style = PaintingStyle.fill
        ..strokeWidth = 2;
      canvas.drawPath(
          getPiecePath(size, imageBox.radiusPoint, imageBox.offsetCenter,
              imageBox.posSide),
          paintDone);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PuzzlePieceClipper extends CustomClipper<Path> {
  PuzzlePieceClipper({
    required this.imageBox,
  });

  ImageBox imageBox;

  @override
  Path getClip(Size size) {
    return getPiecePath(
        size, imageBox.radiusPoint, imageBox.offsetCenter, imageBox.posSide);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

Path getPiecePath(
    Size size,
    double radiusPoint,
    Offset offsetCenter,
    ClassJigsawPos posSide,
    ) {
  final Path path = Path();

  Offset topLeft = const Offset(0, 0);
  Offset topRight = Offset(size.width, 0);
  Offset bottomLeft = Offset(0, size.height);
  Offset bottomRight = Offset(size.width, size.height);

  topLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
      (posSide.top > 0) ? radiusPoint : 0) +
      topLeft;
  topRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
      (posSide.top > 0) ? radiusPoint : 0) +
      topRight;
  bottomRight = Offset(posSide.right > 0 ? -radiusPoint : 0,
      (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomRight;
  bottomLeft = Offset(posSide.left > 0 ? radiusPoint : 0,
      (posSide.bottom > 0) ? -radiusPoint : 0) +
      bottomLeft;

  final double topMiddle = posSide.top == 0
      ? topRight.dy
      : (posSide.top > 0
      ? topRight.dy - radiusPoint
      : topRight.dy + radiusPoint);

  final double bottomMiddle = posSide.bottom == 0
      ? bottomRight.dy
      : (posSide.bottom > 0
      ? bottomRight.dy + radiusPoint
      : bottomRight.dy - radiusPoint);

  final double leftMiddle = posSide.left == 0
      ? topLeft.dx
      : (posSide.left > 0
      ? topLeft.dx - radiusPoint
      : topLeft.dx + radiusPoint);

  final double rightMiddle = posSide.right == 0
      ? topRight.dx
      : (posSide.right > 0
      ? topRight.dx + radiusPoint
      : topRight.dx - radiusPoint);

  path.moveTo(topLeft.dx, topLeft.dy);

  if (posSide.top != 0) {
    path.extendWithPath(
      calculatePoint(Axis.horizontal, topLeft.dy,
          Offset(offsetCenter.dx, topMiddle), radiusPoint),
      Offset.zero,
    );
  }
  path.lineTo(topRight.dx, topRight.dy);

  if (posSide.right != 0) {
    path.extendWithPath(
        calculatePoint(Axis.vertical, topRight.dx,
            Offset(rightMiddle, offsetCenter.dy), radiusPoint),
        Offset.zero);
  }
  path.lineTo(bottomRight.dx, bottomRight.dy);

  if (posSide.bottom != 0) {
    path.extendWithPath(
        calculatePoint(Axis.horizontal, bottomRight.dy,
            Offset(offsetCenter.dx, bottomMiddle), -radiusPoint),
        Offset.zero);
  }
  path.lineTo(bottomLeft.dx, bottomLeft.dy);

  if (posSide.left != 0) {
    path.extendWithPath(
        calculatePoint(Axis.vertical, bottomLeft.dx,
            Offset(leftMiddle, offsetCenter.dy), -radiusPoint),
        Offset.zero);
  }
  path.lineTo(topLeft.dx, topLeft.dy);

  path.close();

  return path;
}

Path calculatePoint(
    Axis axis,
    double fromPoint,
    Offset point,
    double radiusPoint,
    ) {
  final Path path = Path();

  if (axis == Axis.horizontal) {
    path.moveTo(point.dx - radiusPoint / 2, fromPoint);
    path.lineTo(point.dx - radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, point.dy);
    path.lineTo(point.dx + radiusPoint / 2, fromPoint);
  } else if (axis == Axis.vertical) {
    path.moveTo(fromPoint, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy - radiusPoint / 2);
    path.lineTo(point.dx, point.dy + radiusPoint / 2);
    path.lineTo(fromPoint, point.dy + radiusPoint / 2);
  }

  return path;
}
class InvalidImageException implements Exception {
  InvalidImageException();
}
