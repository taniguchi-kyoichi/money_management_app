import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/model/noads_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class AdsDeleteDialog extends ConsumerStatefulWidget {
  const AdsDeleteDialog({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsDeleteDialog> createState() => _AdsDeleteDialogState();
}

class _AdsDeleteDialogState extends ConsumerState<AdsDeleteDialog> {
  Offerings? _offerings;
  bool _restoring = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // 初期化処理
  // 購入情報・Offeringsの取得を行う
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration("public_google_sdk_key");
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_SiOLtpearaoNZVUcXVpVuiKEDai");

      await Purchases.configure(configuration);
      print('configured');
    }

    final offerings = await Purchases.getOfferings();
    print("offerings get");

    if (!mounted) return;

    setState(() {
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_offerings != null) {
      final offering = _offerings!.current;
      if (offering != null) {
        final noAdsPackage = offering.getPackage("noAds");
        if (noAdsPackage != null) {
          return SimpleDialog(
            title: Text('広告非表示'),
            children: [
              SimpleDialogOption(
                child: Text('広告非表示オプションを購入する'),
                onPressed: () async {
                  try {
                    // 購入処理
                    final purchaserInfo =
                        await Purchases.purchasePackage(noAdsPackage);
                    final isNoAds =
                        purchaserInfo.entitlements.all['noAds']!.isActive;
                    if (isNoAds) {
                      // 購入完了時の処理
                      print('購入成功');
                      await NoAdsPurchase().purchase(ref);
                    }
                  } on PlatformException catch (e) {
                    final errorCode = PurchasesErrorHelper.getErrorCode(e);
                    if (errorCode ==
                        PurchasesErrorCode.purchaseCancelledError) {
                      print('User cancelled');
                    } else if (errorCode ==
                        PurchasesErrorCode.purchaseNotAllowedError) {
                      print('User not allowed to purchase');
                    }
                  }
                  Navigator.pop(context, '1が選択されました');
                },
              ),
              SimpleDialogOption(
                child: Text('広告非表示オプションを復元する'),
                onPressed: () async {
                  try {
                    setState(() {
                      _restoring = true;
                    });

                    // 過去の購入情報を取得
                    final restoredInfo = await Purchases.restorePurchases();

                    if (restoredInfo.entitlements.all['noAds'] != null &&
                        restoredInfo.entitlements.all['noAds']!.isActive) {
                      // 復元完了時の処理を記載
                      print('復元成功');
                      await NoAdsPurchase().purchase(ref);

                      // 復元完了のポップアップ
                      var result = await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('確認'),
                            content: Text('復元が完了しました。'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(1),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // 購入情報が見つからない場合
                      var result = await showDialog<int>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('確認'),
                            content:
                                Text('過去の購入情報が見つかりませんでした。アカウント情報をご確認ください。'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () => Navigator.of(context).pop(1),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    setState(() {
                      _restoring = false;
                    });
                  } on PlatformException catch (e) {
                    setState(() {
                      _restoring = false;
                    });
                    final errorCode = PurchasesErrorHelper.getErrorCode(e);
                    print('errorCode: $errorCode');
                  }
                  Navigator.pop(context, '2が選択されました');
                },
              )
            ],
          );
        }
      }
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
