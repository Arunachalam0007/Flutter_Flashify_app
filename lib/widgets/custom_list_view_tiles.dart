// Packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// Widgets
import '../widgets/rounded_image.dart';
import '../widgets/message_bubbles.dart';

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
  final VoidCallback onTap;

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
      onTap: onTap,
      leading: RoundedImageNetworkWithStatusIndicator(
        key: UniqueKey(),
        isActive: isActive,
        imagePath: imageURL,
        size: height / 2,
      ),
      title: Text(
        title,
        style: const TextStyle(
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
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class CustomChatListViewTile extends StatelessWidget {
  final double deviceHeight;
  final double width;
  final ChatMessage message;
  final ChatUser sender;
  final bool isOwnMessage;

  CustomChatListViewTile({
    required this.deviceHeight,
    required this.width,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
            isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !isOwnMessage
              ? RoundedImageNetwork(
                  key: UniqueKey(),
                  imagePath: sender.imageURL,
                  size: width * 0.08,
                )
              : Container(),
          SizedBox(
            width: width * 0.05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubble(
                  message: message,
                  isOwnMessage: isOwnMessage,
                  width: width * 0.75,
                  height: deviceHeight * 0.13)
              : ImageMessageBubble(
                  message: message,
                  isOwnMessage: isOwnMessage,
                  width: width * 0.5,
                  height: deviceHeight * 0.60),
        ],
      ),
    );
  }
}
