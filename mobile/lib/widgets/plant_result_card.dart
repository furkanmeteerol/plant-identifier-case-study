import 'package:flutter/material.dart';

import '../models/plant_result.dart';
import '../theme/app_theme.dart';


class PlantResultCard extends StatelessWidget {
  final PlantResult result;

  const PlantResultCard({
    super.key,
    required this.result,
  });


  @override
  Widget build(BuildContext context) {
    if (!result.isPlant) {
      return Card(
        margin: EdgeInsets.zero,
        color: AppColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(
                Icons.search_off_outlined,
                size: 44,
                color: AppColors.mutedText,
              ),

              const SizedBox(
                height: 12,
              ),

              const Text(
                'No plant detected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w700,
                  color: AppColors.text,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                result.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color:
                      AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      );
    }


    final confidence =
        (result.confidence * 100)
            .toStringAsFixed(0);


    return Card(
      margin: EdgeInsets.zero,
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              result.plantName ??
                  'Unknown plant',
              style: const TextStyle(
                fontSize: 23,
                fontWeight:
                    FontWeight.w700,
                color: AppColors.text,
                letterSpacing: -0.3,
              ),
            ),

            if (result.scientificName !=
                null) ...[
              const SizedBox(
                height: 5,
              ),

              Text(
                result.scientificName!,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle:
                      FontStyle.italic,
                  color:
                      AppColors.secondaryText,
                ),
              ),
            ],

            const SizedBox(
              height: 16,
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration:
                  BoxDecoration(
                color:
                    AppColors.confidenceBackground,
                borderRadius:
                    BorderRadius.circular(
                  10,
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  const Icon(
                    Icons
                        .verified_outlined,
                    size: 18,
                    color:
                        AppColors.confidenceText,
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Text(
                    'Confidence: $confidence%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          AppColors.confidenceText,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 17,
            ),

            Text(
              result.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}