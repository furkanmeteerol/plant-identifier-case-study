import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class PlantHeroCard extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTakePhoto;
  final VoidCallback onGallery;


  const PlantHeroCard({
    super.key,
    required this.imageAsset,
    required this.onTakePhoto,
    required this.onGallery,
  });


  static const Color darkGreen =
      Color(0xFF173D1D);

  static const Color primaryGreen =
      Color(0xFF3F7542);

  static const Color botanicalWhite =
      Color(0xFFF1F5E9);


  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),

        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                darkGreen.withValues(
                  alpha: 0.34,
                ),
                darkGreen.withValues(
                  alpha: 0.12,
                ),
                Colors.transparent,
                Colors.transparent,
                darkGreen.withValues(
                  alpha: 0.90,
                ),
              ],
              stops: const [
                0.0,
                0.14,
                0.30,
                0.52,
                1.0,
              ],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              32,
              20,
              30,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Plant Identifier',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.7,
                      height: 1.0,
                      color: botanicalWhite,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(
                            alpha: 0.24,
                          ),
                          blurRadius: 14,
                          offset:
                              const Offset(0, 2),
                        ),
                        Shadow(
                          color: darkGreen.withValues(
                            alpha: 0.28,
                          ),
                          blurRadius: 24,
                          offset:
                              const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(
                  flex: 5,
                ),

                Text(
                  'Identify any plant.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 34,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.0,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Text(
                  'Take a photo and discover what it is.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    shadows: const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 8,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 22,
                ),

                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: onTakePhoto,
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      size: 21,
                    ),
                    label: Text(
                      'Take a Photo',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Colors.white,
                      foregroundColor:
                          darkGreen,
                      elevation: 0,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                TextButton.icon(
                  onPressed: onGallery,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    size: 19,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Choose from Gallery',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor:
                        Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}