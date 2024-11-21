import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWidget extends StatelessWidget {
  final String path;
  final double size;
  final Color? color;

  const SvgWidget({super.key, required this.path, this.size = 22, this.color});
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/$path.svg',
      height: size,
      width: size,
      // ignore: deprecated_member_use
      color: color,
    );
  }
}
