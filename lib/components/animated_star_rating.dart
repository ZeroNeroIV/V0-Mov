import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimatedStarRating extends StatefulWidget {
  final int starCount;
  final double rating;
  final Function(double) onRatingChanged;
  final Color color;

  const AnimatedStarRating({
    super.key,
    this.starCount = 5,
    this.rating = 0.0,
    required this.onRatingChanged,
    this.color = Colors.amber,
  });

  @override
  State<AnimatedStarRating> createState() => _AnimatedStarRatingState();
}

class _AnimatedStarRatingState extends State<AnimatedStarRating>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildStar(int index) {
    final starValue = index + 1;
    final isSelected = starValue <= widget.rating;

    return GestureDetector(
      onTap: () {
        widget.onRatingChanged(starValue.toDouble());
        _controller.forward(from: 0.0);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: isSelected ? _sizeAnimation.value : 1.0,
            child: Transform.rotate(
              angle: isSelected ? _rotationAnimation.value : 0.0,
              child: Icon(
                isSelected ? Icons.star : Icons.star_border,
                color: widget.color,
                size: 40,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) => buildStar(index)),
    );
  }
}
