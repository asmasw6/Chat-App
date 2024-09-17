import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final double size;
  const RoundedImage({required this.imagePath, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imagePath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              size,
            ),
          ),
          color: Colors.black),
    );
  }
}

class RoundedImageFile extends StatelessWidget {
  final PlatformFile image;
  final double size;

  const RoundedImageFile({required this.image, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: FileImage(File(image.path!)),
          // AssetImage(image.path!),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            size,
          ),
        ),
        color: Colors.black,
      ),
    );
  }
}

class RoundedImagesNetWithStatusIndicator extends RoundedImage {
  final bool isActive;

  const RoundedImagesNetWithStatusIndicator({
    required String imagePath,
    required double size,
    required this.isActive,
    super.key,
  }) : super(
          imagePath: imagePath,
          size: size,
        );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        super.build(context),
        Container(
          height: size * .30,
          width: size * .30,
          decoration: BoxDecoration(
            color: isActive ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(size),
          ),
        )
      ],
    );
  }
}
