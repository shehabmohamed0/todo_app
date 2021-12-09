import 'package:flutter/material.dart';
import 'package:todo_app/app/account/account_page.dart';
import 'package:todo_app/app/home/cupertino_home_scaffold.dart';
import 'package:todo_app/app/home/entries/entries_page.dart';
import 'package:todo_app/app/home/tap_item.dart';

import 'jobs/jobs_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTap = TabItem.jobs;

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  void _select(TabItem tabItem) {
    if (tabItem == _currentTap) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTap = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTap]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTap: _currentTap,
        onSelectTap: _select,
        widgetBuilder: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
