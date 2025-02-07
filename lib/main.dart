import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(WordGameApp());
}

class WordGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WordGameHomePage(),
    );
  }
}

class WordGameHomePage extends StatefulWidget {
  @override
  _WordGameHomePageState createState() => _WordGameHomePageState();
}

class _WordGameHomePageState extends State<WordGameHomePage> {
  final List<String> words = [
    'APPLE',
    'BALL',
    'CAT',
    'DOG',
    'EGG',
    'FROG',
    'HEN',
    'DUCK',
    'BUNNY',
    'TREE',
    'MILK',
    'BIRD',
    'COW',
    'CAR',
    'BOOK',
    'RAIN',
    'SUN',
    'MOON',
    'STAR',
    'FISH',
    'BABY',
    'CHAIR',
    'TABLE',
    'SHOE',
    'HAND',
    'FOOD',
    'WATER',
    'SHEEP',
    'TOY',
    'BLOCK',
    'CAKE',
    'BED',
    'BOX',
    'BAG',
    'HAT',
    'LAMP',
    'JAR',
    'CUP',
    'BALLON',
    'SOAP',
    'DOLL',
    'DOOR',
    'KEY',
    'PEN',
    'PIG',
    'BELL',
    'BEE',
    'GRASS',
    'LEAF',
    'FOOT',
    'JUICE',
    'MOUSE',
    'HORSE',
    'ZIP',
    'NOSE'
  ];
  late String currentWord;
  late List<String> shuffledWord;
  late List<String> userAnswer;

  @override
  void initState() {
    super.initState();
    _generateNewWord();
  }

  void _generateNewWord() {
    setState(() {
      currentWord = words[Random().nextInt(words.length)];
      shuffledWord = currentWord.split('')..shuffle();
      userAnswer = [];
    });
  }

  void _checkAnswer() {
    if (userAnswer.join('') == currentWord) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Correct!'),
          content: Text('You arranged the word correctly!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _generateNewWord();
              },
              child: Text('Next'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Try again!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Arrange the letters to form the word:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: shuffledWord.map((letter) {
                return Draggable<String>(
                  data: letter,
                  child: _buildLetterTile(letter),
                  feedback: _buildLetterTile(letter, dragging: true),
                  childWhenDragging: _buildLetterTile('', empty: true),
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            Wrap(
              spacing: 10,
              children: List.generate(currentWord.length, (index) {
                return DragTarget<String>(
                  onAccept: (receivedLetter) {
                    setState(() {
                      userAnswer.add(receivedLetter);
                      shuffledWord.remove(receivedLetter);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return _buildLetterTile(
                      userAnswer.length > index ? userAnswer[index] : '',
                      empty: userAnswer.length <= index,
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _checkAnswer,
              child: Text('Check Answer'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _resetGame, // ฟังก์ชันสำหรับ Reset
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _shuffleCurrentWord, // ฟังก์ชันสำหรับสุ่มใหม่
                  child: Text('Shuffle Word'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ฟังก์ชันสำหรับ Reset เกม
  void _resetGame() {
    setState(() {
      userAnswer = [];
      _generateNewWord();
    });
  }

  /// ฟังก์ชันสำหรับสุ่มใหม่
  void _shuffleCurrentWord() {
    setState(() {
      shuffledWord.shuffle();
      userAnswer = [];
    });
  }

  Widget _buildLetterTile(String letter,
      {bool dragging = false, bool empty = false}) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: empty
            ? Colors.grey[300]
            : dragging
                ? Colors.blue.withOpacity(0.7)
                : Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        letter,
        style: TextStyle(
          fontSize: 24,
          color: empty ? Colors.grey : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
