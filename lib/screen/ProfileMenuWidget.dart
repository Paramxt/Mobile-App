import 'package:flutter/material.dart';
import 'package:flutter_summer/constants/color.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData? icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ListTile(
      onTap: onPress,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Padding(
        padding:
            const EdgeInsets.fromLTRB(10, 0, 0, 0), // Adjust padding if needed
        child: SizedBox(
          width: 30, // Adjust width if needed
          height: 30, // Adjust height if needed
          child: Center(
            child: Icon(
              icon,
              color: SecondaryColor,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.apply(color: textColor),
      ),
      trailing: endIcon
          ? const Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: SizedBox(
                width: 30,
                height: 30,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18.0,
                  color: Colors.grey,
                ),
              ),
            )
          : null,
    );
  }
}
