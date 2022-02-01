import 'package:flutter/material.dart';
import 'package:money_management_app/View/home.dart';
import 'package:money_management_app/View/event_list_view.dart';

class RootApp extends StatelessWidget {
  const RootApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    int sum = 30000;


    final _kTabPages = <Widget>[
      HomeApp(title: ('title'), sum: sum),
      EventListApp(sum: sum),
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
          title: const Text('appbar title'),
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
