import 'dart:developer';
import 'dart:math' as math;

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:world_without/controllers/game_controller.dart';
import 'package:world_without/models/distance.dart';
import 'package:world_without/models/player.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  void initState() {
    super.initState();

    GameController gameController = context.read<GameController>();

    // Set an initial random point when the app starts
    Future.microtask(() {
      gameController.init();
    });
    gameController.controllerCenter =
        ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameController controller = context.watch<GameController>();
    return Scaffold(
        body: GestureDetector(
      onPanDown: (details) {
        log('Tapped at: ${details.globalPosition}');
        // setState(() {
        //   _points.add(details.globalPosition);
        // });
        controller.tap();
        controller.checkTap(details.globalPosition);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/bg2.jpg'),
                fit: BoxFit.cover,
                colorFilter: controller.isHit && !controller.nextRound
                    ? ColorFilter.mode(
                        Colors.red.withOpacity(0.9), BlendMode.darken)
                    : null,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 45.0),
                child: _buildRoundMessage(controller.players, controller.isHit,
                    controller.currentPlayerTurn, controller.lastKilledPlayer),
              ),
            ),
          ),
          // Positioned(
          //     bottom: 0,
          //     child: ElevatedButton(
          //         onPressed: () {  Colors.purple
          //           init();
          //           _controllerCenter?.stop();
          //           log('Restarting...');
          //         },
          //         child: const Text('Restart'))),
          Align(
            alignment: Alignment.center,
            child: controller.controllerCenter != null
                ? ConfettiWidget(
                    confettiController: controller.controllerCenter!,
                    blastDirectionality: BlastDirectionality
                        .explosive, // don't specify a direction, blast randomly
                    shouldLoop:
                        true, // start again as soon as the animation is finished
                    numberOfParticles: 100,
                    colors: const [
                      Color.fromARGB(255, 141, 97, 121),
                      Color.fromARGB(255, 184, 125, 111),
                      Color.fromARGB(255, 10, 104, 46),
                      Color.fromARGB(255, 224, 255, 139),
                    ], // manually specify the colors to be used
                  )
                : const SizedBox(),
          ),

          if (controller.smallersDistance != null)
            Positioned(
              left: 25,
              top: 35,
              child: Text(
                "${controller.smallersDistance}",
                style: const TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),

          if (controller.players.isNotEmpty)
            ...controller.players.map((player) =>
                _buildPlayer(player, visible: controller.players.length == 1)),
          if (controller.tapPosition != null && controller.isHit)
            Positioned(
              left: controller.tapPosition!.dx - 25,
              top: controller.tapPosition!.dy - 25,
              child: Column(
                children: [
                  Text(
                    controller.lastKilledPlayer?.name ?? "",
                    style: const TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "dead",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    "assets/dead.gif",
                    height: 32,
                  ),
                ],
              ),
            ),
          if (controller.tapPosition != null)
            Positioned(
              left: controller.tapPosition!.dx - 25,
              top: controller.tapPosition!.dy - 25,
              child: Visibility(
                visible: controller.gunShot,
                child: Image.asset(
                  "assets/tap.gif",
                  height: 55,
                ),
              ),
            ),
          // ..._points.map((point) => Positioned(
          //       left: point.dx,
          //       top: point.dy,
          //       child: LottieBuilder.asset(
          //         "assets/lottie/knife.json",
          //         width: 55,
          //       ),
          //     )),
        ],
      ),
    ));
  }

  Widget _buildRoundMessage(List<Player> players, bool isHit,
      int currentPlayerTurn, Player? lastKilledPlayer) {
    // if (nextRound && !_isHit) {
    //   return Text(
    //     'GO !',
    //     textAlign: TextAlign.center,
    //     style: defStyle(),
    //   );
    // }
    if (players.isEmpty) {
      return const Text("...");
    } else {
      if (players.length == 1) {
        return Text(
          "Congratulations! ${players.first.name} wins",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            color: Color.fromARGB(255, 255, 169, 40),
            shadows: [
              Shadow(
                offset: Offset(1.5, 1.5),
                blurRadius: 3.0,
                color: Colors.black,
              ),
            ],
          ),
        );
      } else {
        return isHit
            ? SizedBox(
                child: DefaultTextStyle(
                style: defStyle(),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  pause: const Duration(seconds: 4),
                  animatedTexts: [
                    TyperAnimatedText('${lastKilledPlayer?.name} killed'),
                    TyperAnimatedText(
                        '${players[currentPlayerTurn].name}\'s turn'),
                  ],
                  onTap: () {},
                ),
              ))
            : Text(
                '${players[currentPlayerTurn].name}\'s turn',
                textAlign: TextAlign.center,
                style: defStyle(),
              );
      }
    }
  }

  Widget _buildPlayer(Player player, {bool visible = false}) {
    return Visibility(
      visible: visible,
      child: Positioned(
        left: player.pos.dx,
        top: player.pos.dy,
        child: Column(
          children: [
            Text(
              "${player.name} - the winner",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 3.0,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            Image.asset(
              "assets/sqlett.gif",
              height: 125,
            ),
          ],
        ),
      ),
    );
  }
}

//#64C4C2
//#BFB86A
//#4F8BB0
//#F3CF9D
//#5A4D3C

TextStyle defStyle() => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            offset: Offset(1.5, 1.5),
            blurRadius: 3.0,
            color: Colors.black,
          ),
        ]);
