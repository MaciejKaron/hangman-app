import 'package:flutter/material.dart';
import 'package:hangman/utilities.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class gameScreen extends StatefulWidget {
  const gameScreen({super.key});

  @override
  State<gameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<gameScreen> {
  String password = passwordsList[Random().nextInt(passwordsList.length)];
  List guessedLetters = [];
  int score = 0;
  int gameStatus = 0;
  List pictures = [
    "images/hangman1.png",
    "images/hangman2.png",
    "images/hangman3.png",
    "images/hangman4.png",
    "images/hangman5.png",
    "images/hangman6.png",
    "images/hangman7.png",
    "images/hangman8.png",
  ];
  AudioCache audioCache = AudioCache(prefix: "sounds/");
  bool isSound = true;

  playAudio(String sound) {
    if (isSound) {
      audioCache.play(sound);
    }
  }

  String handleText() {
    String displayedPassword = "";
    for (int i = 0; i < password.length; i++) {
      String char = password[i];
      if (char == "/") {
        displayedPassword += "_ ";
      }
      if (guessedLetters.contains(char)) {
        displayedPassword += char + " ";
      } else {
        if (char != "/") {
          displayedPassword += "? ";
        }
      }
    }
    return displayedPassword;
  }

  checkLetter(String alphabet) {
    if (password.contains(alphabet)) {
      setState(() {
        guessedLetters.add(alphabet);
        score += 5;
      });
      playAudio("click.mp3");
    } else if (gameStatus != 7) {
      setState(() {
        gameStatus += 1;
        score -= 5;
      });
      playAudio("lose.mp3");
    } else {
      openDialog("GAME OVER!");
      playAudio("losev2.mp3");
    }

    bool isWon = true;
    for (int i = 0; i < password.length; i++) {
      String char = password[i];
      if (char != "/") {
        if (!guessedLetters.contains(char)) {
          setState(() {
            isWon = false;
          });
          break;
        }
      }
    }
    if (isWon) {
      openDialog("NICE! YOU WON!");
      playAudio("win.mp3");
    }
  }

  openDialog(String title) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
              decoration: BoxDecoration(color: Colors.red),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: coolStyle(42, Colors.black, FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Your score: $score",
                      style: coolStyle(32, Colors.black, FontWeight.bold),
                      textAlign: TextAlign.center),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 4,
                    child: TextButton(
                      style:
                          TextButton.styleFrom(backgroundColor: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          gameStatus = 0;
                          guessedLetters.clear();
                          score = 0;
                          password = passwordsList[
                              Random().nextInt(passwordsList.length)];
                        });
                      },
                      child: Center(
                        child: Text(
                          "Play again!",
                          style: coolStyle(32, Colors.black, FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          title: Text(
            "Hangman",
            style: coolStyle(60, Colors.red, FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            //leading lewo actions [] prawo
            onPressed: () {
              setState(() {
                isSound = !isSound;
              });
            },
            icon: Icon(
                isSound ? Icons.volume_up_rounded : Icons.volume_off_rounded),
            color: Colors.orange,
            iconSize: 38,
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
            alignment: Alignment.center,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 0),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 6,
                height: 34,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Text(
                  "$score points",
                  style: coolStyle(26, Colors.red, FontWeight.bold),
                )),
              ),
              Image(
                width: 340,
                height: 340,
                image: AssetImage(pictures[gameStatus]),
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // Wyśrodkuj zawartość w poziomie
                    children: [
                      Icon(Icons.heart_broken,
                          color: Colors.red), // Pierwsza ikona (z lewej)
                      Text(
                        "${7 - gameStatus} lives left",
                        style: coolStyle(36, Colors.red, FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Icon(
                        Icons.heart_broken,
                        color: Colors.red,
                      ), // Druga ikona (z prawej)
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                handleText(),
                textAlign: TextAlign.center,
                style: coolStyle(40, Colors.black, FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 13,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 10),
                childAspectRatio: MediaQuery.of(context).size.width / (13 * 70),
                children: letters.map((alphabet) {
                  return InkWell(
                    onTap: () => checkLetter(alphabet),
                    child: Center(
                      child: Text(
                        alphabet,
                        style: coolStyle(50, Colors.black, FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
