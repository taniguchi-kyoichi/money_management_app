import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/View/home.dart';
import 'package:money_management_app/View/event_list_view.dart';
import 'package:money_management_app/configs/constants.dart';
import 'package:money_management_app/view_model/view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    Future(() async {
      await _getPrefItems();
    });
  }

  _getPrefItems() async {
    int result = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    result = prefs.getInt(Constants.availableMoneyPref) ?? 20000;
    _viewModel.setInit(result);
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      HomeApp(ViewModel()),
      EventListApp(ViewModel()),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.home), text: 'ホーム'),
      const Tab(icon: Icon(Icons.history), text: '履歴'),
      const Tab(icon: Icon(Icons.settings), text: '設定'),
    ];
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('交際費管理アプリ'),
          backgroundColor: Colors.cyan,
          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
          bottom: TabBar(
            tabs: _kTabs,
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
