import 'package:flutter/material.dart';


class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
  });


  static const Color primaryGreen =
      Color(0xFF2F6B35);

  static const Color darkGreen =
      Color(0xFF173D1D);

  static const Color textColor =
      Color(0xFF17351B);

  static const Color secondaryTextColor =
      Color(0xFF456149);


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.72,
                ),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.local_florist_rounded,
                color: primaryGreen,
                size: 25,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              'Plant Identifier',
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.w700,
                letterSpacing: -0.2,
                color: textColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Text(
          'Discover the plants\naround you.',
          style: TextStyle(
            fontSize: 34,
            height: 1.04,
            fontWeight:
                FontWeight.w800,
            letterSpacing: -1.0,
            color: textColor,
          ),
        ),

        const SizedBox(height: 11),

        const Text(
          'Take a photo and discover what plant you are looking at.',
          style: TextStyle(
            fontSize: 15,
            height: 1.45,
            color: secondaryTextColor,
          ),
        ),
      ],
    );
  }
}