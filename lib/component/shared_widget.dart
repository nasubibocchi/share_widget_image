import 'package:flutter/material.dart';

/// 画像化したいウィジェットを含むクラス
class SharedWidget extends StatelessWidget {
  const SharedWidget({Key? key, required this.sharedKey}) : super(key: key);

  final GlobalKey sharedKey;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: sharedKey,
      // 画像化したいウィジェットをchildとして指定する
      child: Container(
        height: 50,
        width: 50,
        color: Colors.blue,
        child: const Center(
          child: Text('share'),
        ),
      ),
    );
  }
}
