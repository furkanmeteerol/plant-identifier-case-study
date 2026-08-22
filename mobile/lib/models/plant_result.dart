class PlantResult {
  final bool isPlant;
  final String? plantName;
  final String? scientificName;
  final double confidence;
  final String description;

  const PlantResult({
    required this.isPlant,
    this.plantName,
    this.scientificName,
    required this.confidence,
    required this.description,
  });

  factory PlantResult.fromJson(Map<String, dynamic> json) {
    return PlantResult(
      isPlant: json['is_plant'] as bool,
      plantName: json['plant_name'] as String?,
      scientificName: json['scientific_name'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      description: json['description'] as String,
    );
  }
}