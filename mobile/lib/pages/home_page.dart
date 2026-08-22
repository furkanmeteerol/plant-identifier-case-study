import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../models/plant_result.dart';
import '../services/image_processing_service.dart';
import '../services/plant_api_service.dart';
import '../theme/app_theme.dart';
import '../widgets/plant_hero_card.dart';
import '../widgets/plant_result_card.dart';
import 'crop_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<String> _heroImages = [
    'assets/images/plant_background.jpg',
    'assets/images/plant_cactus.jpg',
    'assets/images/plant_house.jpg',
    'assets/images/plant_flower.jpg',
    'assets/images/plant_leaf.jpg',
  ];

  late final String _heroImage;

  final PlantApiService _apiService =
      const PlantApiService(
    baseUrl: apiBaseUrl,
  );

  final ImageProcessingService _imageProcessingService =
      ImageProcessingService();

  XFile? _originalImage;
  XFile? _selectedImage;

  PlantResult? _plantResult;

  bool _isLoading = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _heroImage = _heroImages[
      Random().nextInt(
        _heroImages.length,
      )
    ];
  }

  Future<void> _identifyPlant() async {
    if (_selectedImage == null) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _plantResult = null;
    });

    try {
      final originalFile = File(
        _selectedImage!.path,
      );

      final processedFile =
          await _imageProcessingService.processImage(
        originalFile,
      );

      final result =
          await _apiService.identifyPlant(
        processedFile,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _plantResult = result;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      String errorMessage;

      if (error is ApiConnectionException) {
        errorMessage =
            'Could not connect to the server. Please check your connection.';
      } else if (error is ApiTimeoutException) {
        errorMessage =
            'The request took too long. Please try again.';
      } else if (error is ApiResponseException) {
        if (error.statusCode >= 500) {
          errorMessage =
              'The plant identification service is temporarily unavailable.';
        } else {
          errorMessage =
              'The image could not be processed. Please try another image.';
        }
      } else {
        errorMessage =
            'Something went wrong. Please try again.';
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorMessage;
      });
    }
  }

  Future<XFile?> _editImage(
    XFile image,
  ) async {
    final croppedBytes =
        await Navigator.push<Uint8List>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => CropPage(
          imagePath: image.path,
        ),
      ),
    );

    if (croppedBytes == null) {
      return null;
    }

    final tempDirectory = Directory.systemTemp;

    final fileName =
        'plant_${DateTime.now().millisecondsSinceEpoch}.png';

    final croppedFile = File(
      '${tempDirectory.path}/$fileName',
    );

    await croppedFile.writeAsBytes(
      croppedBytes,
      flush: true,
    );

    return XFile(
      croppedFile.path,
      mimeType: 'image/png',
    );
  }

  Future<void> _editSelectedImage() async {
    if (_originalImage == null || _isLoading) {
      return;
    }

    final editedImage = await _editImage(
      _originalImage!,
    );

    if (editedImage == null || !mounted) {
      return;
    }

    setState(() {
      _selectedImage = editedImage;
      _plantResult = null;
      _errorMessage = null;
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) {
      return;
    }

    final editedImage = await _editImage(
      image,
    );

    if (editedImage == null || !mounted) {
      return;
    }

    setState(() {
      _originalImage = image;
      _selectedImage = editedImage;
      _plantResult = null;
      _errorMessage = null;
    });
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();

    final image = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (image == null) {
      return;
    }

    final editedImage = await _editImage(
      image,
    );

    if (editedImage == null || !mounted) {
      return;
    }

    setState(() {
      _originalImage = image;
      _selectedImage = editedImage;
      _plantResult = null;
      _errorMessage = null;
    });
  }

  Future<void> _chooseNewPlantImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              12,
              12,
              12,
              16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.mutedText,
                    borderRadius:
                        BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                ListTile(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color:
                        AppColors.brightGreen,
                  ),
                  title: const Text(
                    'Take a Photo',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.camera,
                    );
                  },
                ),
                ListTile(
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color:
                        AppColors.brightGreen,
                  ),
                  title: const Text(
                    'Choose from Gallery',
                    style: TextStyle(
                      color: AppColors.text,
                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      context,
                      ImageSource.gallery,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == ImageSource.camera) {
      await _takePhoto();
    } else if (source == ImageSource.gallery) {
      await _pickImage();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final hasResult =
        _plantResult != null;

    if (!hasResult &&
        _selectedImage == null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value:
            const SystemUiOverlayStyle(
          statusBarColor:
              Colors.transparent,
          statusBarIconBrightness:
              Brightness.light,
          statusBarBrightness:
              Brightness.dark,
          systemNavigationBarColor:
              Colors.transparent,
          systemNavigationBarIconBrightness:
              Brightness.light,
        ),
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.black,
          body: PlantHeroCard(
            imageAsset: _heroImage,
            onTakePhoto: _takePhoto,
            onGallery: _pickImage,
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          const SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,
        statusBarBrightness:
            Brightness.dark,
        systemNavigationBarColor:
            AppColors.background,
        systemNavigationBarIconBrightness:
            Brightness.light,
      ),
      child: Scaffold(
        backgroundColor:
            AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(),
            padding:
                const EdgeInsets.fromLTRB(
              20,
              0,
              20,
              32,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                AnimatedPadding(
                  duration:
                      const Duration(
                    milliseconds: 650,
                  ),
                  curve:
                      Curves.easeInOutCubic,
                  padding:
                      EdgeInsets.only(
                    top: hasResult
                        ? 24
                        : 110,
                  ),
                  child:
                      _buildSelectedImage(),
                ),
                AnimatedSize(
                  duration:
                      const Duration(
                    milliseconds: 650,
                  ),
                  curve:
                      Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    duration:
                        const Duration(
                      milliseconds: 350,
                    ),
                    opacity:
                        hasResult ? 0 : 1,
                    child: hasResult
                        ? const SizedBox(
                            height: 0,
                          )
                        : _buildPreviewActions(),
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(
                    height: 20,
                  ),
                  _buildErrorMessage(),
                ],
                if (hasResult)
                  _buildAnimatedResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImage() {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(24),
      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 650,
        ),
        curve:
            Curves.easeInOutCubic,
        height:
            _plantResult != null
                ? 292
                : 330,
        width: double.infinity,
        decoration:
            const BoxDecoration(
          color:
              AppColors.surface,
        ),
        child: Image.file(
          File(
            _selectedImage!.path,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPreviewActions() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 14,
        ),
        TextButton.icon(
          onPressed: _isLoading
              ? null
              : _editSelectedImage,
          icon: const Icon(
            Icons.edit_outlined,
            size: 18,
          ),
          label: const Text(
            'Edit Photo',
            style: TextStyle(
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor:
                AppColors.brightGreen,
            padding:
                const EdgeInsets.symmetric(
              vertical: 6,
            ),
          ),
        ),
        const SizedBox(
          height: 6,
        ),
        SizedBox(
          height: 56,
          child: FilledButton.icon(
            onPressed: _isLoading
                ? null
                : _identifyPlant,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons
                        .auto_awesome_rounded,
                  ),
            label: Text(
              _isLoading
                  ? 'Identifying...'
                  : 'Identify Plant',
              style:
                  const TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
            style:
                FilledButton.styleFrom(
              backgroundColor:
                  AppColors.primaryGreen,
              foregroundColor:
                  Colors.white,
              disabledBackgroundColor:
                  AppColors.primaryGreen
                      .withValues(
                alpha: 0.28,
              ),
              disabledForegroundColor:
                  Colors.white
                      .withValues(
                alpha: 0.55,
              ),
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
        TextButton(
          onPressed: _isLoading
              ? null
              : _chooseNewPlantImage,
          child: const Text(
            'Choose another image',
            style: TextStyle(
              fontSize: 15,
              color:
                  AppColors.brightGreen,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedResult() {
    return TweenAnimationBuilder<double>(
      key: const ValueKey(
        'plant-result',
      ),
      tween: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ),
      duration:
          const Duration(
        milliseconds: 650,
      ),
      curve:
          Curves.easeOutCubic,
      builder:
          (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(
              0,
              32 * (1 - value),
            ),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          PlantResultCard(
            result: _plantResult!,
          ),
          const SizedBox(
            height: 18,
          ),
          TextButton(
            onPressed:
                _isLoading
                    ? null
                    : _chooseNewPlantImage,
            child: const Text(
              'Identify another plant',
              style: TextStyle(
                fontSize: 15,
                color:
                    AppColors.brightGreen,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding:
          const EdgeInsets.all(18),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFF351B1B),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color:
              const Color(0xFF633333),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons
                .error_outline_rounded,
            color:
                Color(0xFFE57373),
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Text(
              _errorMessage!,
              style: const TextStyle(
                fontSize: 15,
                color:
                    Color(0xFFFFB4AB),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}