import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/fight_club_colors.dart';
import '../resources/fight_club_icons.dart';
import '../resources/fight_club_images.dart';
import '../widgets/action_button.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  String centerText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            const SizedBox(height: 30),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ColoredBox(
                color: FightClubColors.darkPuple,
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                      child: Text(
                    centerText,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: FightClubColors.darkGreyText),
                  )),
                ),
              ),
            )),
            const SizedBox(height: 30),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDependingBodyPart: _selectDependingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(height: 14),
            ActionButton(
                text: yourLives == 0 || enemysLives == 0 ? "Back" : "Go",
                onTap: _onGoButtonClicked,
                color: _getGoButtonColor()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (yourLives == 0 || enemysLives == 0) {
      return FightClubColors.blackButton;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return FightClubColors.greyButton;
    } else {
      return FightClubColors.blackButton;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      Navigator.of(context).pop();
    } else if (defendingBodyPart != null && attackingBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackingBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendingBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives -= 1;
        }
        if (youLoseLife) {
          yourLives -= 1;
        }
        final FightResult? fightResult = FightResult.calculateResult(yourLives, enemysLives);
        if(fightResult!=null){
          SharedPreferences.getInstance().then((sharedPreferences) {
            sharedPreferences.setString("last_fight_result", fightResult.result);
          });
        }

        centerText = _calculateCenterText(youLoseLife, enemyLoseLife);
        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
    }
  }

  String _calculateCenterText(
      final bool youLoseLife, final bool enemyLoseLife) {
    if (enemysLives == 0 && yourLives == 0) {
      return "Draw";
    } else if (yourLives == 0) {
      return "You lost!";
    } else if (enemysLives == 0) {
      return "You won!";
    } else {
      final String first = enemyLoseLife
          ? "You hit enemy's ${attackingBodyPart!.name.toLowerCase()}."
          : "Your attack was blocked.";
      final String second = youLoseLife
          ? "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
          : "Enemy's attack was blocked.";
      return "$first\n$second";
    }
  }

  void _selectDependingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      defendingBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(final BodyPart value) {
    if (yourLives == 0 || enemysLives == 0) {
      return;
    }
    setState(() {
      attackingBodyPart = value;
    });
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            Expanded(
                child: ColoredBox(
              color: Colors.white,
            )),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, FightClubColors.darkPuple],
                  ),
                ),
              ),
            ),
            Expanded(
                child: ColoredBox(
              color: Color(0xFFC5D1EA),
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LivesWidget(
              overallivesCount: maxLivesCount,
              currentlivesCount: yourLivesCount,
            ),
            Column(children: [
              const SizedBox(height: 16),
              Text(
                "You",
                style: TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 12),
              Image.asset(
                FightClubImages.youAvatar,
                height: 92,
                width: 92,
              )
            ]),
            SizedBox(
              height: 44,
              width: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: FightClubColors.blueButton),
                child: Center(
                  child: Text(
                    "vs",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            Column(children: [
              const SizedBox(height: 16),
              const Text("Enemy",
                  style: TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 12),
              Image.asset(
                FightClubImages.enemyAvatar,
                height: 92,
                width: 92,
              )
            ]),
            LivesWidget(
              overallivesCount: maxLivesCount,
              currentlivesCount: enemysLivesCount,
            )
          ],
        ),
      ]),
    );
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendingBodyPart;
  final ValueSetter<BodyPart> selectDependingBodyPart;

  final BodyPart? attackingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget(
      {Key? key,
      required this.defendingBodyPart,
      required this.selectDependingBodyPart,
      required this.attackingBodyPart,
      required this.selectAttackingBodyPart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text("Defend".toUpperCase(),
                  style: TextStyle(color: FightClubColors.darkGreyText)),
              const SizedBox(height: 13),
              BodyPartButton(
                text: BodyPart.head,
                selected: defendingBodyPart == BodyPart.head,
                bodyPartSetter: selectDependingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                text: BodyPart.torso,
                selected: defendingBodyPart == BodyPart.torso,
                bodyPartSetter: selectDependingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                text: BodyPart.legs,
                selected: defendingBodyPart == BodyPart.legs,
                bodyPartSetter: selectDependingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text(
                "Attack".toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText),
              ),
              const SizedBox(height: 13),
              BodyPartButton(
                text: BodyPart.head,
                selected: attackingBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                text: BodyPart.torso,
                selected: attackingBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              const SizedBox(height: 14),
              BodyPartButton(
                text: BodyPart.legs,
                selected: attackingBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallivesCount;
  final int currentlivesCount;

  const LivesWidget(
      {Key? key,
      required this.overallivesCount,
      required this.currentlivesCount})
      : assert(overallivesCount >= 1),
        assert(currentlivesCount >= 0),
        assert(currentlivesCount <= overallivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(overallivesCount, (index) {
        if (index < currentlivesCount) {
          return [
            Image.asset(FightClubIcons.heartFull, height: 18, width: 18),
            if (index < overallivesCount - 1) SizedBox(height: 4)
          ];
        } else {
          return [
            Image.asset(FightClubIcons.heartEmpty, height: 18, width: 18),
            if (index < overallivesCount - 1) SizedBox(height: 4)
          ];
        }
      }).expand((element) => element).toList(),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() {
    return 'BodyPart{name: $name}';
  }

  static const List<BodyPart> _values = [head, torso, legs];

  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart text;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton(
      {Key? key,
      required this.text,
      required this.selected,
      required this.bodyPartSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(text),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected ? FightClubColors.blueButton : Colors.transparent,
            border: !selected
                ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                : null,
          ),
          child: Center(
              child: Text(
            text.name.toUpperCase(),
            style: TextStyle(
                color: selected
                    ? FightClubColors.whiteText
                    : FightClubColors.darkGreyText),
          )),
        ),
      ),
    );
  }
}
