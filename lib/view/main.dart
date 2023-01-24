import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/View/root_tab_view.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  //向き指定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,//縦固定
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'money management app',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: RootApp(ViewModel()),
    );
  }
}
