import 'package:flutter/material.dart';

class BorderButton extends StatelessWidget {
  const BorderButton({
    required this.onTap,
    required this.isloading,
    required this.text,
    super.key,
  });
  final void Function()? onTap;
  final bool isloading;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: isloading ? Theme.of(context).primaryColor : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(5),
            ),
            border: Border.all(
              width: 2,
              color: Theme.of(context).primaryColor,
            )),
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
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  )),
      ),
    );
  }
}
