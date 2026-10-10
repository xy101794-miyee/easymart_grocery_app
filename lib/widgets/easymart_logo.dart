import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EasymartLogo extends StatelessWidget {
  final double width;
  final double? height;
  final bool showTagline;

  const EasymartLogo({
    super.key,
    this.width = 260,
    this.height,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          'assets/images/easymart_logo.svg',
          width: width,
          height: height,
        ),
        if (showTagline)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'EASY SHOP, SMART CHOICE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: const Color(0xFF1C2F45),
                letterSpacing: 1.2,
              ),
            ),
          ),
      ],
    );
  }
}
