import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_club_colors.dart';
import 'package:flutter_fight_club/fight_club_icons.dart';
import 'package:flutter_fight_club/fight_club_images.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const maxLivves = 5;

  BodyPart? defendingBodyPart;
  BodyPart? attackingBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLivves;
  int enemysLives = maxLivves;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD5DEF0),
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLivves,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            const Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: SizedBox(
                width: double.infinity,
                child: ColoredBox(
                  color: Color(0xFFC5D1EA),
                  child: Center(
                      child: Text(
                    "Your attack was blocked.\nEnemy’s attack was blocked.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  )),
                ),
              ),
            )),
            ControlsWidget(
                defendingBodyPart: defendingBodyPart,
                selectDependingBodyPart: _selectDependingBodyPart,
                attackingBodyPart: attackingBodyPart,
                selectAttackingBodyPart: _selectAttackingBodyPart),
            const SizedBox(height: 14),
            GoButton(
                text: yourLives == 0 || enemysLives == 0
                    ? "Start new game"
                    : "Go",
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
      return Colors.black87;
    } else if (attackingBodyPart == null || defendingBodyPart == null) {
      return Colors.black38;
    } else {
      return Colors.black87;
    }
  }

  void _onGoButtonClicked() {
    if (yourLives == 0 || enemysLives == 0) {
      setState(() {
        yourLives = maxLivves;
        enemysLives = maxLivves;
      });
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

        whatEnemyDefends = BodyPart.random();
        whatEnemyAttacks = BodyPart.random();

        attackingBodyPart = null;
        defendingBodyPart = null;
      });
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

class GoButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const GoButton({
    Key? key,
    required this.text,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 40,
          child: ColoredBox(
            color: color,
            child: Center(
              child: Text(
                text.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Color(0xDEFFFFFF)),
              ),
            ),
          ),
        ),
      ),
    );
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
          children: [
            Expanded(
                child: ColoredBox(
              color: Colors.white,
            )),
            Expanded(
                child: ColoredBox(
              color: FightClubColors.darkPuple,
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
            ColoredBox(
              color: Colors.green,
              child: SizedBox(height: 44, width: 44),
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
          return Padding(
            padding: EdgeInsets.only(bottom: index< overallivesCount-1 ? 4 : 0),
            child: Image.asset(
              FightClubIcons.heartFull,
              height: 18,
              width: 18,
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.only(bottom: index< overallivesCount-1 ? 4 : 0),
            child: Image.asset(
              FightClubIcons.heartEmpty,
              height: 18,
              width: 18,
            ),
          );
        }
      }),
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
        child: ColoredBox(
          color: selected
              ? FightClubColors.blueButton
              : FightClubColors.greyButton,
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
