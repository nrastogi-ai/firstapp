import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
void main() {
  runApp(const StakeDiceGame());
}

class StakeDiceGame extends StatefulWidget {
  const StakeDiceGame({super.key});

  @override
  State<StakeDiceGame> createState() => _StakeDiceGameState();
}

class _StakeDiceGameState extends State<StakeDiceGame> {
  int walletBal = 10;
  int? maxWagerAmt;
  String selection = '';
  String msg = '';
  final TextEditingController wagerControl = TextEditingController();

  @override
  void dispose() {
    wagerControl.dispose();
    super.dispose();
  }

  void _diceRoll() {
    setState(() {
      msg = 'Select a Game Mode:';
    });

    final wagerAmtEntered = int.tryParse(wagerControl.text);
    if (wagerAmtEntered == null || wagerAmtEntered <= 0) {
      setState(() {
        msg = 'Enter a valid wager amount.';
      });
      return;
    }

    // Set max wager amount based on selected multiplier
    if (selection == '*2') {
      maxWagerAmt = walletBal ~/ 2;
    } else if (selection == '*3') {
      maxWagerAmt = walletBal ~/ 3;
    } else if (selection == '*4') {
      maxWagerAmt = walletBal ~/ 4;
    }

    // Check if wager exceeds max
    if (wagerAmtEntered > maxWagerAmt!) {
      setState(() {
        msg = 'Insufficient Wager amount.';
      });
      return;
    }

    final random = Random();
    int die1 = random.nextInt(6) + 1;
    int die2 = random.nextInt(6) + 1;
    int die3 = random.nextInt(6) + 1;
    int die4 = random.nextInt(6) + 1;

    // Group dice to check for matches
    Map<int, int> grouped = {};
    for (int die in [die1, die2, die3, die4]) {
      grouped[die] = (grouped[die] ?? 0) + 1;
    }

    int multiplier = 0;
    if (selection == '*2' && grouped.containsValue(2)) {
      multiplier = 2;
    } else if (selection == '*3' && grouped.containsValue(3)) {
      multiplier = 3;
    } else if (selection == '*4' && grouped.containsValue(4)) {
      multiplier = 4;
    }

    // Update wallet balance based on multiplier
    if (multiplier > 0) {
      setState(() {
        walletBal += wagerAmtEntered * multiplier;
        msg = 'Dice: [$die1, $die2, $die3, $die4]\nYou won ${wagerAmtEntered * multiplier}';
      });
    } else {
      setState(() {
        walletBal -= wagerAmtEntered;
        msg = 'Dice: [$die1, $die2, $die3, $die4]\nYou lost $wagerAmtEntered';
      });
    }
    wagerControl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Stake Dice Game',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.pink,
        ),
        backgroundColor: Colors.purple,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 20),
            Text(
              'Current Wallet Balance: \$ $walletBal',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selection = '*2';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selection == '*2' ? Colors.blue : null,
                  ),
                  child: const Text('*2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selection = '*3';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selection == '*3' ? Colors.blue : null,
                  ),
                  child: const Text('*3'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selection = '*4';
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selection == '*4' ? Colors.blue : null,
                  ),
                  child: const Text('*4'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: wagerControl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: 'Enter a valid wager amount:',
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.yellow,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (msg.isNotEmpty)
              Text(
                msg,
                style: const TextStyle(
                  //color: Colors.BuildContext,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _diceRoll,
              child: const Text('LETS ROLL'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
