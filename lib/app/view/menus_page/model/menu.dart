import 'package:flutter/Material.dart';

class Menu {
  const Menu({
    required this.image,
    required this.gradient,
    required this.pageOpen,
    required this.isLoginRequired,
    required this.icon,
    required this.title,
    required this.titleIconColor,
    required this.isComingSoon,
  });

  final ImageProvider<Object> image;
  final Gradient gradient;
  final String pageOpen;
  final bool isLoginRequired;
  final IconData icon;
  final String title;
  final Color titleIconColor;
  final bool isComingSoon;
}
