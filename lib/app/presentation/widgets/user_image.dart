import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImage extends StatefulWidget {
  UserImage({
    super.key,
    required this.image,
    required this.icon,
    required this.onImageSelect,
  });

  XFile? image;
  IconData icon;
  Function onImageSelect;

  @override
  State<UserImage> createState() => _UserImageState();
}

class _UserImageState extends State<UserImage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          widget.onImageSelect();
          if (widget.image != null) {
            widget.icon = Icons.edit;
          }
        },
        child: Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(120),
              border: Border.all(color: Colors.black, width: 1),
              image: widget.image == null
                  ? const DecorationImage(
                      image: NetworkImage(
                          "https://i1.sndcdn.com/artworks-IrhmhgPltsdrwMu8-thZohQ-t500x500.jpg"),
                      fit: BoxFit.cover)
                  : DecorationImage(
                      image: FileImage(File(widget.image!.path)),
                      fit: BoxFit.cover)),
          child: Align(
            alignment: widget.image != null
                ? Alignment.bottomCenter
                : Alignment.center,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(36)),
              child: Icon(widget.icon, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
