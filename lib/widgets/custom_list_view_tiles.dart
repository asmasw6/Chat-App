import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sukoon/models/chat_message.dart';
import 'package:sukoon/models/chat_user.dart';
import 'package:sukoon/widgets/message.bubbles.dart';
import 'package:sukoon/widgets/rounded_image.dart';

class CustomListViewTilesWithActivity extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActivity;
  final bool isActive;

  final Function onTap;
  const CustomListViewTilesWithActivity({
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isActivity,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * .20,
      leading: RoundedImagesNetWithStatusIndicator(
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
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
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(
                  color: Colors.white54,
                  size: height * .1,
                )
              ],
            )
          : Text(
              subTitle,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
    );
  }
}

class CustomeChatListViewTile extends StatelessWidget {
  final double width;
  final double height;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;
  const CustomeChatListViewTile({
    required this.height,
    required this.width,
    required this.isOwnMessage,
    required this.message,
    required this.sender,
    super.key,
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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          !isOwnMessage
              ? RoundedImage(
                  imagePath: sender.imageURL,
                  size: width * .12,
                )
              : Container(),
          SizedBox(
            width: width * .05,
          ),
          message.type == MessageType.TEXT
              ? TextMessageBubble(
                  height: height * 0.06,
                  width: width,
                  isOwnMessage: isOwnMessage,
                  message: message)
              : ImageMessageBubbles(
                  height: height * .30,
                  width: width * .55,
                  isOwnMessage: isOwnMessage,
                  message: message,
                )
        ],
      ),
    );
  }
}

class CustomListViewTiles extends StatelessWidget {
  final double height;
  final String title;
  final String subTitle;
  final String imagePath;
  final bool isActive;
  final bool isSlected;
  final Function onTap;

  CustomListViewTiles({
    required this.height,
    required this.title,
    required this.subTitle,
    required this.imagePath,
    required this.isActive,
    required this.isSlected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSlected
          ? const Icon(
              Icons.check,
              color: Colors.white,
            )
          : null,
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImagesNetWithStatusIndicator(
        imagePath: imagePath,
        size: height / 2,
        isActive: isActive,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subTitle,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
