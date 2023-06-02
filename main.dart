import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';

void main() {
  runApp(MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Master',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://t3.ftcdn.net/jpg/01/78/63/34/360_F_178633426_U5MZNWHx2Y35XmuNonNxnJKqJAqUmEy7.jpg'),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,
          appBar: AppBar(
centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              )
            ),
            shadowColor: Colors.grey,
            backgroundColor: Colors.blue,
            title: Text('Math Master'),
            elevation: 0,
          ),
          body: Container(
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(20.0),
                  onPrimary: Colors.black45,
                  onSurface: Colors.grey,
                ),
                child: Text('Start Game'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LevelSelectionScreen()),
                  );
                },
              ),
            ),
          )));
}

class LevelSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Select Level'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                onPrimary: Colors.black45,
                onSurface: Colors.grey,
              ),
              child: Text('Level 1'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(level: 1)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Level 2'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                onPrimary: Colors.black45,
                onSurface: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(level: 2)),
                );
              },
            ),
            ElevatedButton(
              child: Text('Level 3'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15.0),
                onPrimary: Colors.black45,
                onSurface: Colors.grey,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen(level: 3)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionModel {
  final String trueAnswer;
  final String answerA;
  final String answerB;
  final String answerC;
  final String answerD;
  final String questionText;

  QuestionModel({
    required this.trueAnswer,
    required this.answerA,
    required this.answerB,
    required this.answerC,
    required this.answerD,
    required this.questionText,
  });
}

class GameScreen extends StatefulWidget {
  final int level;

  GameScreen({required this.level});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int currentQuestionIndex = 0;
  List<QuestionModel> questions = [];
  int timerSeconds = 10;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    switch (widget.level) {
      case 1:
        questions = level1;
        break;
      case 2:
        questions = level2;
        break;
      case 3:
        questions = level3;
        break;
    }
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timerSeconds > 0) {
          timerSeconds--;
        } else {
          timer.cancel();
          nextQuestion();
        }
      });
    });
  }

  void checkAnswer(String selectedAnswer) {
    String trueAnswer = questions[currentQuestionIndex].trueAnswer;

    if (selectedAnswer == trueAnswer) {
      setState(() {
        score++;
      });
    }
    timer?.cancel();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timerSeconds = 10;
        startTimer();
      });
    } else {
      timer?.cancel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ScoreScreen(score: score)),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    QuestionModel currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Math Game - Level ${widget.level}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Score: $score'),
            Text('Time Left: $timerSeconds seconds'),
            Text('Question: ${currentQuestion.questionText}'),
            ElevatedButton(
              child: Text(currentQuestion.answerA),
              onPressed: () {
                checkAnswer(currentQuestion.answerA);
                nextQuestion();
              },
            ),
            ElevatedButton(
              child: Text(currentQuestion.answerB),
              onPressed: () {
                checkAnswer(currentQuestion.answerB);
                nextQuestion();
              },
            ),
            ElevatedButton(
              child: Text(currentQuestion.answerC),
              onPressed: () {
                checkAnswer(currentQuestion.answerC);
                nextQuestion();
              },
            ),
            ElevatedButton(
              child: Text(currentQuestion.answerD),
              onPressed: () {
                checkAnswer(currentQuestion.answerD);
                nextQuestion();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreScreen extends StatelessWidget {
  final int score;

  ScoreScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Game Over'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Final Score: $score'),
            ElevatedButton(
              child: Text('Play Again'),
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
    );
  }
}

List<QuestionModel> level1 = [
  QuestionModel(
    trueAnswer: "5",
    answerA: "5",
    answerB: "6",
    answerC: "8",
    answerD: "10",
    questionText: "8-3",
  ),
  QuestionModel(
    trueAnswer: "15",
    answerA: "19",
    answerB: "20",
    answerC: "7",
    answerD: "15",
    questionText: "20-5",
  ),
  QuestionModel(
      trueAnswer: "4",
      answerA: "5",
      answerB: "8",
      answerC: "7",
      answerD: "4",
      questionText: "19-15"),
  QuestionModel(
      trueAnswer: "20",
      answerA: "15",
      answerB: "20",
      answerC: "17",
      answerD: "19",
      questionText: "15+5"),
  QuestionModel(
      trueAnswer: "13",
      answerA: "14",
      answerB: "15",
      answerC: "13",
      answerD: "17",
      questionText: "8+5"),
  QuestionModel(
      trueAnswer: "8",
      answerA: "6",
      answerB: "8",
      answerC: "12",
      answerD: "16",
      questionText: "12-4"),
  QuestionModel(
      trueAnswer: "7",
      answerA: "10",
      answerB: "4",
      answerC: "7",
      answerD: "17",
      questionText: "15-8"),
  QuestionModel(
      trueAnswer: "9",
      answerA: "9",
      answerB: "15",
      answerC: "18",
      answerD: "13",
      questionText: "19-10"),
  QuestionModel(
      trueAnswer: "22",
      answerA: "18",
      answerB: "22",
      answerC: "17",
      answerD: "5",
      questionText: "19+3"),
  QuestionModel(
      trueAnswer: "10",
      answerA: "14",
      answerB: "18",
      answerC: "12",
      answerD: "10",
      questionText: "25-15"),
  // Add more level 1 questions here...
];

List<QuestionModel> level2 = [
  QuestionModel(
    trueAnswer: "25",
    answerA: "30",
    answerB: "25",
    answerC: "14",
    answerD: "16",
    questionText: "5*(9-4)",
  ),
  QuestionModel(
    trueAnswer: "36",
    answerA: "25",
    answerB: "36",
    answerC: "48",
    answerD: "60",
    questionText: "6*6",
  ),
  QuestionModel(
      trueAnswer: "15",
      answerA: "19",
      answerB: "20",
      answerC: "7",
      answerD: "15",
      questionText: "3*5"),
  QuestionModel(
      trueAnswer: "25",
      answerA: "25",
      answerB: "20",
      answerC: "18",
      answerD: "15",
      questionText: "5*5"),
  QuestionModel(
      trueAnswer: "72",
      answerA: "63",
      answerB: "72",
      answerC: "54",
      answerD: "64",
      questionText: "8*9"),
  QuestionModel(
      trueAnswer: "48",
      answerA: "54",
      answerB: "48",
      answerC: "81",
      answerD: "25",
      questionText: "6*8"),
  QuestionModel(
      trueAnswer: "27",
      answerA: "36",
      answerB: "25",
      answerC: "27",
      answerD: "15",
      questionText: "9*3"),
  QuestionModel(
      trueAnswer: "18",
      answerA: "17",
      answerB: "15",
      answerC: "16",
      answerD: "18",
      questionText: "6*3"),
  QuestionModel(
      trueAnswer: "45",
      answerA: "45",
      answerB: "27",
      answerC: "72",
      answerD: "15",
      questionText: "9*5"),
  QuestionModel(
      trueAnswer: "60",
      answerA: "60",
      answerB: "45",
      answerC: "73",
      answerD: "18",
      questionText: "6*10"),
  // Add more level 2 questions here...
];

List<QuestionModel> level3 = [
  QuestionModel(
    trueAnswer: "8",
    answerA: "10",
    answerB: "5",
    answerC: "8",
    answerD: "10",
    questionText: "36/9+4",
  ),
  QuestionModel(
    trueAnswer: "15",
    answerA: "25",
    answerB: "42",
    answerC: "18",
    answerD: "15",
    questionText: "(90+30)/10+3",
  ),
  QuestionModel(
      trueAnswer: "45",
      answerA: "52",
      answerB: "45",
      answerC: "72",
      answerD: "16",
      questionText: "3*(20-5)"),
  QuestionModel(
      trueAnswer: "1",
      answerA: "40",
      answerB: "15",
      answerC: "1",
      answerD: "16",
      questionText: "13-3*4"),
  QuestionModel(
      trueAnswer: "0",
      answerA: "30",
      answerB: "0",
      answerC: "72",
      answerD: "10",
      questionText: "15-5*3"),
  QuestionModel(
      trueAnswer: "90",
      answerA: "16",
      answerB: "28",
      answerC: "45",
      answerD: "90",
      questionText: "30*(4-1)"),
  QuestionModel(
      trueAnswer: "13",
      answerA: "18",
      answerB: "24",
      answerC: "13",
      answerD: "10",
      questionText: "24/3+5"),
  QuestionModel(
      trueAnswer: "48",
      answerA: "54",
      answerB: "63",
      answerC: "48",
      answerD: "81",
      questionText: "6*(4+4)"),
  QuestionModel(
      trueAnswer: "50",
      answerA: "60",
      answerB: "84",
      answerC: "45",
      answerD: "50",
      questionText: "10*(9-4)"),
  QuestionModel(
      trueAnswer: "23",
      answerA: "39",
      answerB: "23",
      answerC: "17",
      answerD: "45",
      questionText: "5*4+3"),
  // Add more level 3 questions here...
];
