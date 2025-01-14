import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/environment.dart';
import 'package:money_management_app/extension/ios_widget_manager.dart';
import 'package:money_management_app/view/event_list_view.dart';
import 'package:money_management_app/view/settings_view.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/provider.dart';
import 'home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    //adUnitId: 'ca-app-pub-4395078331214572/5958752150',
    //adUnitId: "ca-app-pub-3940256099942544/2934735716",
    adUnitId: Platform.isIOS ? Environment().iosAdmobBannerUnitID : Environment().androidAdmobBannerUnitID,
    size: AdSize.fullBanner,
    request: request,
    listener: const BannerAdListener(),
  );

  static const AdRequest request = AdRequest();

  _getPrefItems() async {
    int result = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = prefs.getInt(Constants.availableMoneyPref) ?? _viewModel.aimMoney;
    await _viewModel.setInit(result);


  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      HomeApp(viewModel: ViewModel()),
      EventListApp(ViewModel()),
      SettingsApp(ViewModel()),
    ];
    final _kTabs = <Tab>[
      Tab(icon: const Icon(Icons.home), text: L10n.of(context)!.home,),
      Tab(icon: const Icon(Icons.history), text: L10n.of(context)!.history),
      Tab(icon: const Icon(Icons.settings), text: L10n.of(context)!.settings),
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
          child: Stack(
            children: [
              TabBarView(
                children: _kTabPages,
              ),
             Platform.isIOS ?  SafeArea(child: adStack(myBanner)) : const Padding(padding: EdgeInsets.zero),
            ],
          ),
        ),
      ),
    );
  }

  Widget adStack(_bannerAd) {
    final AdWidget adWidget = AdWidget(ad: _bannerAd);
    final Container adContainer = Container(
      alignment: Alignment.center,
      width: _bannerAd.size.width.toDouble(),
      height: _bannerAd.size.height.toDouble(),
      child: adWidget,
    );

    return ref.watch(isNoAdsPurchaseProvider) ? const Padding(padding: EdgeInsets.zero) : Center(
      child: Column(
        children: [
          const Expanded(
              child: Padding(
                padding: EdgeInsets.zero,
              )),
          const SizedBox(
            height: 30,
          ),
          adContainer,
        ],
      ),
    );
  }
}
