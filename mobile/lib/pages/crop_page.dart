import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper_widget/image_cropper_widget.dart';

import '../theme/app_theme.dart';

class CropPage extends StatefulWidget {
  final String imagePath;

  const CropPage({
    super.key,
    required this.imagePath,
  });

  @override
  State<CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final ImageCropperController _controller =
      ImageCropperController();

  bool _isProcessing = false;
  bool _rotateMode = false;

  double _rotationRadians = 0;

  void _setRotation(double radians) {
    final clampedRadians = radians.clamp(
      -math.pi,
      math.pi,
    );

    setState(() {
      _rotationRadians = clampedRadians;
    });

    _controller.setRotation(clampedRadians);
  }

  void _rotateBy90(double direction) {
    _setRotation(
      _rotationRadians +
          (direction * math.pi / 2),
    );
  }

  String _rotationLabel() {
    final degrees =
        (_rotationRadians * 180 / math.pi).round();

    if (degrees == 0) {
      return '0°';
    }

    return '${degrees > 0 ? '+' : ''}$degrees°';
  }

  Future<void> _cropAndSave() async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final Uint8List? bytes =
          await _controller.crop();

      if (!mounted) {
        return;
      }

      if (bytes == null) {
        setState(() {
          _isProcessing = false;
        });
        return;
      }

      Navigator.pop(
        context,
        bytes,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isProcessing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not edit the image. Please try again.',
          ),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 64,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: const Text(
            'Edit Photo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainToolbar() {
    return SizedBox(
      height: 82,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            _CropToolbarIcon(
              icon: Icons.close_rounded,
              color: Colors.white,
              tooltip: 'Cancel',
              onPressed: _isProcessing
                  ? null
                  : () {
                      Navigator.pop(context);
                    },
            ),
            _CropToolbarIcon(
              icon: Icons.rotate_right_rounded,
              color: Colors.white,
              tooltip: 'Rotate',
              onPressed: _isProcessing
                  ? null
                  : () {
                      setState(() {
                        _rotateMode = true;
                      });
                    },
            ),
            _CropToolbarIcon(
              icon: Icons.check_rounded,
              color: Colors.white,
              tooltip: 'Done',
              onPressed: _isProcessing
                  ? null
                  : _cropAndSave,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRotateToolbar() {
    return SizedBox(
      height: 150,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            8,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: _isProcessing
                        ? null
                        : () {
                            setState(() {
                              _rotateMode = false;
                            });
                          },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.text,
                    ),
                    tooltip: 'Back',
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Rotate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    _rotationLabel(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brightGreen,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _isProcessing
                          ? null
                          : () => _rotateBy90(-1),
                      icon: const Icon(
                        Icons.rotate_left_rounded,
                        size: 26,
                        color: AppColors.text,
                      ),
                      tooltip: 'Rotate 90° left',
                    ),
                    Expanded(
                      child: Slider(
                        value: _rotationRadians.clamp(
                          -math.pi,
                          math.pi,
                        ),
                        min: -math.pi,
                        max: math.pi,
                        divisions: 360,
                        label: _rotationLabel(),
                        onChanged: _isProcessing
                            ? null
                            : _setRotation,
                      ),
                    ),
                    IconButton(
                      onPressed: _isProcessing
                          ? null
                          : () => _rotateBy90(1),
                      icon: const Icon(
                        Icons.rotate_right_rounded,
                        size: 26,
                        color: AppColors.text,
                      ),
                      tooltip: 'Rotate 90° right',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                color: AppColors.background,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: ImageCropperWidget(
                  image: FileImage(
                    File(widget.imagePath),
                  ),
                  controller: _controller,
                  aspectRatio: null,
                  fit: BoxFit.contain,
                  style: CropperStyle(
                    overlayColor: Colors.black.withValues(
                      alpha: 0.48,
                    ),
                    borderColor:
                        AppColors.primaryGreen,
                    borderWidth: 2,
                    handlerColor:
                        AppColors.primaryGreen,
                    handlerSize: 22,
                    handleType: HandleType.circle,
                    handlerThickness: 3,
                    cropBorderRadius: 0,
                    overlayPadding: 0,
                    enableFeedback: true,
                    enableScaleAnimation: true,
                    showGrid: false,
                    cropShape: CropShape.rectangle,
                  ),
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 180,
              ),
              child: _rotateMode
                  ? _buildRotateToolbar()
                  : _buildMainToolbar(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CropToolbarIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback? onPressed;

  const _CropToolbarIcon({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: 64,
        minHeight: 64,
      ),
      icon: Icon(
        icon,
        size: 30,
        color: onPressed == null
            ? AppColors.mutedText
            : color,
      ),
    );
  }
}