import 'package:flutter/material.dart';

class AdsDeleteDialog extends StatelessWidget {
  const AdsDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('広告非表示'),
      children: [
        SimpleDialogOption(
          child: Text('広告非表示オプションを購入する'),
          onPressed: () {
            Navigator.pop(context, '1が選択されました');
          },
        ),
        SimpleDialogOption(
          child: Text('広告非表示オプションを復元する'),
          onPressed: () {
            Navigator.pop(context, '2が選択されました');
          },
        )
      ],
    );
  }
}
