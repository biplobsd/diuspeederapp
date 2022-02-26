import 'dart:ui';

import 'package:flutter/Material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    Key? key,
    required this.blur,
    required this.opacity,
    required this.child,
  }) : super(key: key);
  final double blur;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
          ),
          child: child,
        ),
      ),
    );
  }
}
