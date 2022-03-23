import 'package:flutter/material.dart';

import '../resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const SecondaryActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          alignment: Alignment.center,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(
                  color: FightClubColors.darkGreyText, width: 2)),
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Color(0XFF161616),
            ),
          )),
    );
  }
}
