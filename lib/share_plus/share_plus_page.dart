import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sns_share_comparison/component/shared_widget.dart';

/// share実行クラス。シェアボタン（など）のクラスに関数を置くのが良さそう。
class SharePlusPage extends StatelessWidget {
  SharePlusPage({Key? key}) : super(key: key);

  final sharedKey = GlobalKey();

  Future<void> _onTapShareButton(
      {required String text, required GlobalKey globalKey}) async {
    //shareする際のテキスト
    try {
      final bytes = await _exportToImage(globalKey);
      //byte data→Uint8List
      final widgetImageBytes =
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
      //App directoryファイルに保存
      final applicationDocumentsFile =
          await _getApplicationDocumentsFile(text, widgetImageBytes);

      final path = applicationDocumentsFile.path;

      await Share.shareWithResult('file://$path', subject: 'image');

      applicationDocumentsFile.delete();
    } catch (error) {
      print(error);
    }
  }

  Future<ByteData> _exportToImage(GlobalKey globalKey) async {
    final boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!;
  }

  Future<File> _getApplicationDocumentsFile(
      String text, List<int> imageData) async {
    final directory = await getApplicationDocumentsDirectory();

    final exportFile = File('${directory.path}/$text.png');
    if (!await exportFile.exists()) {
      await exportFile.create(recursive: true);
    }
    final file = await exportFile.writeAsBytes(imageData);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SharedWidget(sharedKey: sharedKey),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: () async => await _onTapShareButton(
                  text: 'image_component', globalKey: sharedKey),
              label: const Text('share'),
              icon: const Icon(Icons.ios_share),
            ),
          ],
        ),
      ),
    );
  }
}
