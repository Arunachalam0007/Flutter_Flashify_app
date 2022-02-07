// Packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Widgets
import '../widgets/rounded_image.dart';

// Models
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class CustomListViewTileWithActivity extends StatelessWidget {
  final String title;
  final String subTtile;
  final String imageURL;
  final bool isActive;
  final bool isActivity;
  final double height;
  final Function onTap;

  const CustomListViewTileWithActivity({
    required this.title,
    required this.subTtile,
    required this.imageURL,
    required this.isActive,
    required this.isActivity,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: height * 0.20, // SpaceBetween
      onTap: onTap(),
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        isActive: isActive,
        imagePath: imageURL,
        size: height / 2,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: isActivity
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: height * 0.10,
                )
              ],
            )
          : Text(
              subTtile,
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}
