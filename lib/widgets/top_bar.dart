// Packages
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  String _title;
  Widget? primaryAction;
  Widget? secondarAction;
  double? titleFontSize;

  TopBar(
    this._title, {
    this.primaryAction,
    this.secondarAction,
    this.titleFontSize = 30,
  });

  late double _deviceHeight;
  late double _deviceWidth;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return _buildUI();
  }

  Widget _buildUI() {
    return Container(
      height: _deviceWidth * 0.20,
      width: _deviceWidth,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (primaryAction != null) primaryAction!,
          _titleBar(),
          if (secondarAction != null) secondarAction!,
        ],
      ),
    );
  }

  Text _titleBar() {
    return Text(
      _title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Colors.white,
        fontSize: titleFontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
