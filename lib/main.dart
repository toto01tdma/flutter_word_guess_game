import 'package:flutter/material.dart';
import 'dart:math'; // ใช้สำหรับการสุ่มคำศัพท์แบบสุ่ม

void main() {
  runApp(
      WordGameApp()); // ฟังก์ชันหลักที่เริ่มต้นแอปพลิเคชันและเรียกใช้ WordGameApp
}

class WordGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Game', // ชื่อของแอปพลิเคชัน
      theme: ThemeData(
        primarySwatch: Colors.blue, // ธีมของแอปพลิเคชันใช้สีหลักเป็นสีน้ำเงิน
      ),
      home: WordGameHomePage(), // กำหนดหน้าแรกของแอปพลิเคชัน
    );
  }
}

class WordGameHomePage extends StatefulWidget {
  @override
  _WordGameHomePageState createState() =>
      _WordGameHomePageState(); // สร้าง State สำหรับหน้าหลัก
}

class _WordGameHomePageState extends State<WordGameHomePage> {
  final List<String> words = [
    // ลิสต์คำศัพท์ที่ใช้ในเกม
    'APPLE', 'BALL', 'CAT', 'DOG', 'EGG', 'FROG', 'HEN', 'DUCK', 'BUNNY',
    'TREE', 'MILK', 'BIRD', 'COW', 'CAR', 'BOOK', 'RAIN', 'SUN', 'MOON',
    'STAR', 'FISH', 'BABY', 'CHAIR', 'TABLE', 'SHOE', 'HAND', 'FOOD',
    'WATER', 'SHEEP', 'TOY', 'BLOCK', 'CAKE', 'BED', 'BOX', 'BAG', 'HAT',
    'LAMP', 'JAR', 'CUP', 'BALLON', 'SOAP', 'DOLL', 'DOOR', 'KEY', 'PEN',
    'PIG', 'BELL', 'BEE', 'GRASS', 'LEAF', 'FOOT', 'JUICE', 'MOUSE',
    'HORSE', 'ZIP', 'NOSE'
  ];
  late String currentWord; // คำศัพท์ปัจจุบันที่สุ่มขึ้นมา
  late List<String> shuffledWord; // ตัวอักษรในคำศัพท์ที่ถูกสุ่มเรียงใหม่
  late List<String> userAnswer; // คำตอบที่ผู้ใช้จัดเรียง

  @override
  void initState() {
    super.initState();
    _generateNewWord(); // เรียกใช้ฟังก์ชันเพื่อสุ่มคำศัพท์เมื่อเริ่มต้น
  }

  void _generateNewWord() {
    setState(() {
      currentWord =
          words[Random().nextInt(words.length)]; // สุ่มคำศัพท์จากรายการ
      shuffledWord = currentWord.split('')
        ..shuffle(); // แยกคำศัพท์เป็นตัวอักษรและสุ่มเรียงใหม่
      userAnswer = []; // รีเซ็ตคำตอบของผู้ใช้ให้ว่างเปล่า
    });
  }

  void _checkAnswer() {
    if (userAnswer.join('') == currentWord) {
      // ตรวจสอบว่าคำตอบของผู้ใช้ตรงกับคำศัพท์หรือไม่
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Correct!'), // แสดงข้อความ "Correct!" หากคำตอบถูกต้อง
          content: Text('You arranged the word correctly!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด Dialog
                _generateNewWord(); // สุ่มคำใหม่
              },
              child: Text('Next'), // ปุ่มสำหรับไปยังคำใหม่
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Try again!')), // แสดงข้อความหากคำตอบผิด
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Game'), // ชื่อใน AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // จัดเรียง Widgets ให้อยู่กึ่งกลาง
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Arrange the letters to form the word:', // ข้อความนำสำหรับเกม
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20), // ระยะห่างระหว่างข้อความและตัวอักษร
            Wrap(
              spacing: 10, // ระยะห่างระหว่างตัวอักษร
              children: shuffledWord.map((letter) {
                // แสดงตัวอักษรที่สุ่มเรียง
                return Draggable<String>(
                  data: letter, // กำหนดข้อมูลเป็นตัวอักษร
                  child: _buildLetterTile(letter), // แสดงตัวอักษร
                  feedback: _buildLetterTile(letter,
                      dragging: true), // แสดงตัวอักษรขณะลาก
                  childWhenDragging:
                      _buildLetterTile('', empty: true), // ช่องว่างขณะลาก
                );
              }).toList(),
            ),
            SizedBox(height: 40),
            Wrap(
              spacing: 10, // ระยะห่างระหว่างช่องคำตอบ
              children: List.generate(currentWord.length, (index) {
                return DragTarget<String>(
                  onAccept: (receivedLetter) {
                    setState(() {
                      userAnswer.add(receivedLetter); // เพิ่มตัวอักษรลงในคำตอบ
                      shuffledWord
                          .remove(receivedLetter); // ลบตัวอักษรออกจากตัวเลือก
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return _buildLetterTile(
                      userAnswer.length > index
                          ? userAnswer[index]
                          : '', // แสดงตัวอักษรที่ผู้ใช้เลือก
                      empty: userAnswer.length <=
                          index, // ช่องว่างหากยังไม่มีตัวอักษร
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _checkAnswer, // ตรวจสอบคำตอบเมื่อกดปุ่ม
              child: Text('Check Answer'), // ข้อความในปุ่ม
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // จัดปุ่มให้อยู่กึ่งกลาง
              children: [
                ElevatedButton(
                  onPressed: _resetGame, // ฟังก์ชันสำหรับ Reset เกม
                  child: Text('Reset'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _shuffleCurrentWord, // ฟังก์ชันสำหรับสุ่มคำใหม่
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
      shuffledWord = currentWord.split('')
        ..shuffle(); // สุ่มตัวอักษรใหม่จากคำเดิม
      userAnswer = []; // เคลียร์คำตอบของผู้ใช้
    });
  }

  /// ฟังก์ชันสำหรับสุ่มเรียงตัวอักษรใหม่
  void _shuffleCurrentWord() {
    setState(() {
      shuffledWord.shuffle(); // สุ่มตำแหน่งตัวอักษรใหม่
      userAnswer = []; // รีเซ็ตคำตอบของผู้ใช้
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
            ? Colors.grey[300] // สีเทาอ่อนสำหรับช่องว่าง
            : dragging
                ? Colors.blue.withOpacity(0.7) // สีฟ้าจางขณะลาก
                : Colors.blue, // สีฟ้าสำหรับตัวอักษรปกติ
        borderRadius: BorderRadius.circular(10), // มุมโค้งของ Tile
      ),
      child: Text(
        letter, // ตัวอักษรที่จะแสดง
        style: TextStyle(
          fontSize: 24, // ขนาดตัวอักษร
          color: empty ? Colors.grey : Colors.white, // สีตัวอักษร
          fontWeight: FontWeight.bold, // ความหนาของตัวอักษร
        ),
      ),
    );
  }
}
