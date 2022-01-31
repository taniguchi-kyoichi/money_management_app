import 'package:flutter/material.dart';
import 'package:money_management_app/View/home.dart';
import 'package:money_management_app/View/sqlite_example.dart';

class TabsExample extends StatelessWidget {
  const TabsExample({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    int sum = 30000;


    final _kTabPages = <Widget>[
      MyHomePage(title: ('title'), sum: sum),
      SqliteExample(sum: sum),
      const Center(child: Icon(Icons.forum, size: 64.0, color: Colors.blue)),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.cloud), text: 'Tab1'),
      const Tab(icon: Icon(Icons.alarm), text: 'Tab2'),
      const Tab(icon: Icon(Icons.forum), text: 'Tab3'),
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
