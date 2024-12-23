import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_without/controllers/game_controller.dart';
import 'package:world_without/game_page.dart';
import 'package:world_without/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GameController gameController = context.read<GameController>();

    // Set an initial random point when the app starts
    Future.microtask(() {
      gameController.initSound();
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              width: 145,
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return const GamePage();
                // }));

                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          insetPadding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          content: Consumer<GameController>(
                            builder: (c, controller, _) => Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset('assets/wall.png',
                                    width: width,
                                    height: height,
                                    fit: BoxFit.cover),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Text("How many people?", style: defStyle()),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                        height: height * .35,
                                        child:
                                            Image.asset("assets/people.png")),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.setPlayersCount(2);
                                          },
                                          child: Opacity(
                                            opacity:
                                                controller.playersCount == 2
                                                    ? 1
                                                    : 0.5,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/button.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                width: 75,
                                                height: 75,
                                                child: Center(
                                                  child: Text(
                                                    "2",
                                                    textAlign: TextAlign.center,
                                                    style: defStyle(),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.setPlayersCount(4);
                                          },
                                          child: Opacity(
                                            opacity:
                                                controller.playersCount == 4
                                                    ? 1
                                                    : 0.5,
                                            child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(25)),
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/button.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                width: 75,
                                                height: 75,
                                                child: Center(
                                                  child: Text(
                                                    "4",
                                                    textAlign: TextAlign.center,
                                                    style: defStyle(),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Positioned(
                                    bottom: 0,
                                    child: Row(
                                      children: [
                                        DefaultButton(
                                          text: "Back",
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        DefaultButton(
                                          text: "Start",
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const GamePage();
                                            }));
                                          },
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          )

                          // Container(
                          //   decoration: const BoxDecoration(
                          //     image: DecorationImage(
                          //       image: AssetImage('assets/wall.png'),
                          //       fit: BoxFit.contain,
                          //     ),
                          //   ),
                          //   width: width * 0.8,
                          //   height: height * 0.8,
                          //   child: Center(
                          //     child: Text(
                          //       "Welcome to the Game!",
                          //       style:
                          //           TextStyle(fontSize: 20, color: Colors.white),
                          //     ),
                          //   ),
                          // ),
                          );
                    });
              },
              child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/button.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: 200,
                  height: 50,
                  child: Center(
                    child: Text(
                      "New Game",
                      textAlign: TextAlign.center,
                      style: defStyle(),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const DefaultButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/button.png'),
              fit: BoxFit.cover,
            ),
          ),
          width: 200,
          height: 50,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          )),
    );
  }
}
