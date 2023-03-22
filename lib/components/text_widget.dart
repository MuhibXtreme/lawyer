import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String? text;
  final double? size;
  final FontWeight? fontWeight;
  final Color? textcolor;
  final double? letterspacing;
  final AlignmentGeometry? alignment;
  final int? maxlines;
  const TextWidget(
      {Key? key,
      this.size,
      this.text,
      this.fontWeight,
      this.textcolor,
      this.letterspacing,
      this.alignment,this.maxlines
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      child: Text(
        '$text',maxLines: maxlines,
        style: TextStyle(
          color: textcolor,
          fontSize: size,
          fontWeight: fontWeight,
          letterSpacing: letterspacing,
        ),
      ),
    );
  }
}
