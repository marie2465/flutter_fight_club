import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                "Statistics",
                style: const TextStyle(
                  color: FightClubColors.darkGreyText,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return const SizedBox();
                }
                final SharedPreferences sp = snapshot.data!;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Won: ${sp.getInt("stats_won")?? 0}",
                      style: TextStyle(
                          fontSize: 16, color: FightClubColors.darkGreyText),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Lost: ${sp.getInt("stats_lost")?? 0}",
                      style: TextStyle(
                          fontSize: 16, color: FightClubColors.darkGreyText),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Draw: ${sp.getInt("stats_draw")?? 0}",
                      style: TextStyle(
                          fontSize: 16, color: FightClubColors.darkGreyText),
                    ),
                    SizedBox(height: 6),
                  ],
                );
              },
            ),
            Expanded(child: SizedBox.shrink()),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SecondaryActionButton(
                  text: "Back",
                  onTap: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
