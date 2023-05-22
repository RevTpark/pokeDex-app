import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadHeader extends StatelessWidget {
  const UploadHeader({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.w),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(29, 214, 255, 0.5),
                  blurRadius: 15.0,
                  spreadRadius: -18.0),
            ],
            color: Colors.white24,
            border: Border.all(color: Colors.lightBlue),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: child
      );
  }
}
