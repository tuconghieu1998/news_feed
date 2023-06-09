import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:news_feed/modules/home/blocs/home_feed_rxdart_bloc.dart';
import 'package:news_feed/modules/home/blocs/list_posts_rxdart_bloc.dart';
import 'package:news_feed/modules/home/pages/home_page.dart';
import 'package:news_feed/modules/message/pages/list_message_page.dart';
import 'package:news_feed/modules/notification/blocs/notification_bloc.dart';
import 'package:news_feed/modules/notification/pages/notification_page.dart';
import 'package:news_feed/modules/profile/blocs/profile_bloc.dart';
import 'package:news_feed/modules/profile/pages/my_profile_page.dart';
import 'package:news_feed/providers/bloc_provider.dart';
import 'package:news_feed/themes/app_colors.dart';
import 'package:news_feed/utils/asset_utils.dart';
import 'package:news_feed/utils/image_utils.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  static const String routeName = "/main_app";

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    BlocProvider(
      child: HomePage(),
      bloc: ListPostRxDartBloc()..getPosts()),
    Text(
      'Index 1: Stream',
      style: optionStyle,
    ),
    const ListMessagePage(),
    BlocProvider(
      bloc: NotificationBloc()..getNotifications(),
      child: const NotificationPage()),
    BlocProvider(
      bloc: ProfileBloc()..getUserDetail(),
      child: MyProfilePage())
  ];
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 10,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[       
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetUtils.icoHome)),
            label: 'Home',
            backgroundColor: AppColor.backgroundBottomNavigation,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetUtils.icoStream)),
            label: 'Streams',
            backgroundColor: AppColor.backgroundBottomNavigation,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetUtils.icoMessage)),
            label: 'Messages',
            backgroundColor: AppColor.backgroundBottomNavigation,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetUtils.icoNotification)),
            label: 'Notifications',
            backgroundColor: AppColor.backgroundBottomNavigation,
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(AssetUtils.icoProfile)),
            label: 'Profiles',
            backgroundColor: AppColor.backgroundBottomNavigation,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.primaryColor,
        unselectedItemColor: AppColor.unselectItems,
        backgroundColor: AppColor.backgroundBottomNavigation,
        onTap: _onItemTapped,
      ),
    );
  }
}