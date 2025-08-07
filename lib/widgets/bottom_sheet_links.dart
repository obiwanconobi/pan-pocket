import 'package:flutter/material.dart';

class BottomSheetLinks extends StatefulWidget {
  const BottomSheetLinks({super.key});

  @override
  State<BottomSheetLinks> createState() => _BottomSheetLinksState();
}

class _BottomSheetLinksState extends State<BottomSheetLinks> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
