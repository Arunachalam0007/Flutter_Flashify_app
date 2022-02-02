import 'package:flutter/material.dart';

class NavigationService{
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToRoute( String _route){
    navigatorKey.currentState?.pushNamed(_route);
  }

  // Remove the Current page screen and add new page screen
  void popAndNavigateToRoute(String _route){
    navigatorKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToPage(Widget _page){
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context)=> _page),);
  }

  void goBack(){
    navigatorKey.currentState?.pop();
  }
}