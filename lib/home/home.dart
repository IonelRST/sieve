import 'package:flutter/material.dart';
import 'dart:math';

import 'package:sieve_of_eratosthenes/models/prime.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //[numbers] is the List where we have all the numbers that we
  //want to check
  static List<int> numbers = [for (int i = 2; i < 1003; i++) i];

  //[remainingNumbers] is the List where we are going to substract
  //all the numbers we already checked
  List<int> remainingNumbers = [for (int i = 2; i < 1003; i++) i];

  //[primeNumbers] is the array List we are going to save all the
  //prime numbers and their random colors
  List<Prime> primeNumbers = [];

  @override
  void initState() {
    _checkPrimeNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sieve of Eratosthenes'),
      ),
      body: _content(),
    );
  }

  Widget _content() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [_primeNumbersList(), _checkNumbersList(), _restartButton()],
      ),
    );
  }

  //[_checkNumbersList] allows to show all the numbers that have to
  //be checked, number that have been checked have a color
  Widget _checkNumbersList() {
    return ExpansionTile(
        initiallyExpanded: true,
        title: const Text("All the numbers to check"),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              children: [
                for (int value in numbers)
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    color: getColorByPrime(value),
                    width: 40,
                    height: 40,
                    child: Center(child: Text('$value')),
                  )
              ],
            ),
          )
        ]);
  }

  //[_primeNumbersList] allows to show all the prime numbers that
  //we have been found
  Widget _primeNumbersList() {
    return ExpansionTile(
      title: const Text("All prime numbers!"),
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              for (Prime value in primeNumbers)
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: value.primeColor),
                      color: value.primeColor),
                  margin: const EdgeInsets.all(4.0),
                  height: 20,
                  width: 40,
                  child: Center(child: Text("${value.primeNumber}")),
                )
            ],
          ),
        ),
      ],
    );
  }

  //[_restartButton] allows to restart the prime search
  Widget _restartButton() {
    return ElevatedButton(
        onPressed: _checkPrimeNumber, child: const Text("Do it again!"));
  }

  //[_checkPrimeNumber] function that check all numbers that haven't
  //been check and get the prime numbers
  void _checkPrimeNumber() async {
    //clear List
    primeNumbers.clear();
    remainingNumbers = [for (int i = 2; i < 1003; i++) i];
    //if we still have numbers that aren't checked
    while (remainingNumbers.isNotEmpty) {
      //the first item of [remainingNumbers] will always be
      //a prime number
      int nextNum = remainingNumbers.first;
      primeNumbers
          .add(Prime(primeNumber: nextNum, primeColor: newPrimeColor()));

      //iteration on numbers to check if it's divisible
      for (var value in numbers) {
        if (value % nextNum == 0) {
          remainingNumbers.remove(value);
        }
        setState(() {});
      }
      //we have to remove [nextNum] to take the next prime
      remainingNumbers.remove(nextNum);

      //this is only to allow the app to show the process
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  //each time we call this function it will return a diferent color
  Color newPrimeColor() {
    Color randomColor = Color(Random().nextInt(4294967296));
    while (primeNumbers
            .indexWhere((element) => element.primeColor == randomColor) !=
        -1) {
      randomColor = Color(Random().nextInt(4294967296));
    }
    return randomColor;
  }

  //[getColorByPrime] returns a color depending on last number that
  //[num] is divisible for
  Color getColorByPrime(int num) {
    int index = primeNumbers
        .lastIndexWhere((element) => num % element.primeNumber == 0);
    return index != -1 ? primeNumbers[index].primeColor : Colors.white;
  }
}
