import 'package:flutter/material.dart';
import 'package:tic_tac_toe/ui/theme/color.dart';

import 'utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastvalue = "X";
  bool gameOver = false;
  String result = '';
  List<int> scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0];
  int turn = 0;

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: MainColor.primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${lastvalue}  turn".toUpperCase(),
              style: TextStyle(
                  color: Colors.pink[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 50),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: boardWidth,
              height: boardWidth,
              child: GridView.count(
                crossAxisCount: Game.boardLength ~/ 3,
                padding: EdgeInsets.all(16.0),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: List.generate(Game.boardLength, (index) {
                  return InkWell(
                    onTap: gameOver
                        ? null
                        : () {
                            if (game.board![index] == "") {
                              setState(() {
                                game.board![index] = lastvalue;
                                turn++;
                                gameOver = game.winnerCheck(
                                    lastvalue, index, scoreBoard, 3);
                                if (gameOver) {
                                  result = "$lastvalue is the Winner";
                                } else if (!gameOver && turn == 9) {
                                  result = "It's a Draw";
                                  gameOver = true;
                                }
                                if (lastvalue == "X")
                                  lastvalue = "O";
                                else
                                  lastvalue = "X";
                              });
                            }
                          },
                    child: Container(
                      width: Game.blockSize,
                      height: Game.blockSize,
                      decoration: BoxDecoration(
                          color: MainColor.secondaryColor,
                          borderRadius: BorderRadius.circular(16.0)),
                      child: Center(
                        child: Text(
                          game.board![index],
                          style: TextStyle(
                              fontSize: 64.0,
                              fontWeight: FontWeight.bold,
                              color: game.board![index] == 'X'
                                  ? Colors.yellow
                                  : Colors.white),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              result,
              style: TextStyle(
                  color: Colors.purple[400],
                  fontSize: 54.0,
                  fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  game.board = Game.initGameBoard();
                  lastvalue = "X";
                  gameOver = false;
                  turn = 0;
                  result = '';
                  scoreBoard = [0, 0, 0, 0, 0, 0, 0, 0, 0];
                });
              },
              icon: Icon(Icons.replay),
              label: Text("Repeat the Game"),
            ),
          ],
        ));
  }
}
