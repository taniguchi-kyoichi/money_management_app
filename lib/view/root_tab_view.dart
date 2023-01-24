import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_management_app/View/event_list_view.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/extension/ios_widget_manager.dart';
import 'package:money_management_app/view/settings_view.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class RootApp extends ConsumerStatefulWidget {
  final ViewModel viewModel;

  const RootApp(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<RootApp> createState() => _RootAppState();
}

class _RootAppState extends ConsumerState<RootApp> {
  late ViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.setRef(ref);
    myBanner.load();
    Future(() async {
      await _getPrefItems();
    });
  }

  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/2934735716',
    size: AdSize.banner,
    request: request,
    listener: const BannerAdListener(),
  );

  static const AdRequest request = AdRequest();

  _getPrefItems() async {
    int result = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = prefs.getInt(Constants.availableMoneyPref) ?? _viewModel.aimMoney;
    _viewModel.setInit(result);

    // iosウィジェットを初期化
    IosWidgetManager().initMethodChannel();
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      HomeApp(viewModel: ViewModel(), myBanner: myBanner),
      EventListApp(ViewModel()),
      SettingsApp(ViewModel()),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.home), text: 'ホーム',),
      const Tab(icon: Icon(Icons.history), text: '履歴'),
      const Tab(icon: Icon(Icons.settings), text: '設定'),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TabBar(
                tabs: _kTabs,
              ),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: TabBarView(
            children: _kTabPages,
          ),
        ),
      ),
    );
  }
}
