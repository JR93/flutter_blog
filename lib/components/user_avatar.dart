import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zhiku/common/consts.dart';

class UserAvatar extends StatelessWidget {
  final String avatar;
  final double size;

  UserAvatar({ Key key, @required this.avatar, this.size = 20.0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: avatar,
      imageBuilder: (context, imageProvider) => _genUserAvatar(
        image: imageProvider,
        size: size,
      ),
      errorWidget: (context, url, error) => _genUserAvatar(
        image: NetworkImage(DEFAULT_AVATAR),
        size: size,
      ),
    );
  }

  /*
   * _genUserAvatar: 生成头像UI
   */
  Widget _genUserAvatar({ImageProvider image, double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}