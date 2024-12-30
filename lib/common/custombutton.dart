import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.onTap,
    required this.isloading,
    required this.text,
    this.disabledColor,
    this.enabledColor,
    this.textColor,
    super.key,
  });
  final void Function()? onTap;
  final bool isloading;
  final String text;
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: onTap == null ? disabledColor : enabledColor,
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        width: double.infinity,
        height: 50,
        child: Center(
            child: isloading
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                      strokeCap: StrokeCap.round,
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                        color: textColor != null
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                        fontSize: 16),
                  )),
      ),
    );
  }
}
