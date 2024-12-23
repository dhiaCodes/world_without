import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:world_without/models/distance.dart';
import 'dart:developer';
import 'dart:math' as math;

import 'package:world_without/models/player.dart';

class GameController extends ChangeNotifier {
  final bgplayer = AudioPlayer();
  final sfxPLayer = AudioPlayer();
  final sfxPLayer2 = AudioPlayer();

  initSound() async {
    await bgplayer.play(AssetSource('audio/bg.mp3'));
  }

  deadSOund() async {
    // RANDOM SOUND
    final random = math.Random().nextInt(2);

    await sfxPLayer.play(AssetSource('audio/dead-0.mp3'));
  }

  tap() async {
    await sfxPLayer2.play(AssetSource('audio/tap.mp3'));
  }

  bool twov2SoundPlaying = false;
  twov2Sound() async {
    if (twov2SoundPlaying) return;
    await bgplayer.play(AssetSource('audio/2v2.mp3'));
    twov2SoundPlaying = true;
  }

  Offset? tapPosition; // The user's tap position
  double tolerance = 50.0; // Tolerance radius for checking
  bool isHit = false;

  Offset? initialPoint;
  final List<Player> players = [];
  int currentPlayerTurn = 0;
  List<Offset> playersPoints = []; // The initial point to find

  int playersCount = 2;
  void setPlayersCount(int count) {
    playersCount = count;
    notifyListeners();
  }

  void init() {
    playersPoints.clear();
    players.clear();

    playersPoints = _generateInitialPLayersPoints(playersCount);
    for (int i = 0; i < playersPoints.length; i++) {
      players
          .add(Player(id: i, name: 'Player ${i + 1}', pos: playersPoints[i]));
    }
    //  _players.shuffle();
    currentPlayerTurn = 0;
    notifyListeners();
  }

  Player? lastKilledPlayer;
  double? smallersDistance;
  void killPlayerAt(Distance distance) {
    deadSOund();
    log('Killing player at: ${distance.toPlayerId}');

    lastKilledPlayer =
        players.firstWhere((player) => player.id == distance.toPlayerId);

    players.remove(lastKilledPlayer);
    playersPoints.remove(lastKilledPlayer?.pos);

    log('Players: ${players.map((e) => e.name).toList()}');
  }

  final allDistances = <Distance>[];
  bool nextRound = false;

  bool gunShot = false;
  bool showBomb = false;

  Future checkTap(Offset tapPos) async {
    gunShot = true;
    notifyListeners();
    if (players.length <= 1) return;
    allDistances.clear();

    for (final player in players) {
      final distance = Distance(
          value: (player.pos - tapPos).distance.roundToDouble(),
          toPlayerId: player.id);
      allDistances.add(distance);
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      gunShot = false;
      notifyListeners();
    });
    log('All distances: ${allDistances.map((e) => e.value).toList()}');
    // tri the distances from smallest to largest
    allDistances.sort((a, b) => a.value.compareTo(b.value));
    final distance = allDistances.first;
    smallersDistance = distance.value;
    log('Smallest distance: ${distance.value}');

    nextRound = false;
    tapPosition = tapPos;

    isHit = distance.value <= tolerance; // Check if within tolerance
    if (players.length == 2) {
      twov2Sound();
    }

    if (isHit) {
      killPlayerAt(distance);

      currentPlayerTurn = (currentPlayerTurn + 1) % players.length;

      if (players.length == 1) {
        controllerCenter?.play();

        // await Future.delayed(const Duration(seconds: 7));
        // showBomb = true;
        // notifyListeners();
        // await Future.delayed(const Duration(seconds: 3));
        // showBomb = false;
        // notifyListeners();
        return;
      }

      //_controllerCenter?.play();
      //  _generateInitialPoint(); // Generate a new point on a hit
    } else {
      currentPlayerTurn = (currentPlayerTurn + 1) % players.length;
    }

    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));

    nextRound = true;

    notifyListeners();
  }

  Offset? _offset;
  List<Offset> _points = <Offset>[];
  ConfettiController? controllerCenter;
}

List<Offset> _generateInitialPLayersPoints(int count) {
  // Generate a random position for the initial point
  final List<Offset> list = <Offset>[];

  for (int i = 0; i < count; i++) {
    list.add(Offset(
        math.Random().nextDouble() * 700, math.Random().nextDouble() * 300));
  }

  log('Initial points: $list');

  return list;
}
