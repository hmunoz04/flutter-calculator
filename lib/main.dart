import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator by Herik',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';
  bool _hasResult = false;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _expression = '';
        _result = '';
        _hasResult = false;
      } else if (value == '=') {
        _evaluate();
      } else if (value == 'x²') {
        _applySquare();
      } else {
        if (_hasResult) {
          // Start new expression after result
          if (RegExp(r'[0-9.]').hasMatch(value)) {
            _expression = value;
          } else {
            _expression = _result + value;
          }
          _result = '';
          _hasResult = false;
        } else {
          _expression += value;
        }
      }
    });
  }

  void _applySquare() {
    if (_hasResult && _result.isNotEmpty && _result != 'Error') {
      _expression = '($_result)^2';
      _result = '';
      _hasResult = false;
      return;
    }
    if (_expression.isEmpty) return;
    final regex = RegExp(r'(\d+\.?\d*)$');
    final match = regex.firstMatch(_expression);
    if (match != null) {
      final lastNumber = match.group(0)!;
      final start = match.start;
      final end = match.end;
      _expression = _expression.replaceRange(start, end, '($lastNumber)^2');
    }
  }

  void _evaluate() {
    try {
      String exp = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/');
      double evalResult = _evaluateSimple(exp);
      _result = evalResult.toString();
      _expression = '$_expression = $_result';
      _hasResult = true;
    } catch (e) {
      _result = 'Error';
      _expression = '';
      _hasResult = true;
    }
  }

  // Simple evaluator: supports +, -, *, /, ^2 (as (^2)), and decimals.
  double _evaluateSimple(String exp) {
    // Handle squares: replace (number)^2 with (number*number)
    exp = exp.replaceAllMapped(
      RegExp(r'\((\-?\d+\.?\d*)\)\^2'),
      (m) {
        final n = double.parse(m.group(1)!);
        return (n * n).toString();
      },
    );
    // Remove spaces
    exp = exp.replaceAll(' ', '');

    // Tokenize
    final tokens = <String>[];
    final buffer = StringBuffer();
    for (int i = 0; i < exp.length; i++) {
      final c = exp[i];
      if ('0123456789.'.contains(c)) {
        buffer.write(c);
      } else if ('+-*/'.contains(c)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(c);
      }
    }
    if (buffer.isNotEmpty) tokens.add(buffer.toString());

    // Evaluate left to right (no operator precedence)
    double result = double.parse(tokens[0]);
    for (int i = 1; i < tokens.length; i += 2) {
      String op = tokens[i];
      double num = double.parse(tokens[i + 1]);
      if (op == '+') {
        result += num;
      } else if (op == '-') {
        result -= num;
      } else if (op == '*') {
        result *= num;
      } else if (op == '/') {
        result /= num;
      }
    }
    return result;
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[200],
            foregroundColor: textColor ?? Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 22),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator by Herik'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[700],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 18),
            color: Colors.blueGrey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(fontSize: 28, color: Colors.black87),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_result.isNotEmpty && _result != 'Error')
                  Text(
                    _result,
                    style: const TextStyle(fontSize: 36, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                if (_result == 'Error')
                  const Text(
                    'Error',
                    style: TextStyle(fontSize: 32, color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton('7'),
                    _buildButton('8'),
                    _buildButton('9'),
                    _buildButton('÷', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('4'),
                    _buildButton('5'),
                    _buildButton('6'),
                    _buildButton('×', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('1'),
                    _buildButton('2'),
                    _buildButton('3'),
                    _buildButton('-', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('0'),
                    _buildButton('.'),
                    _buildButton('x²', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                    _buildButton('+', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('C', color: Colors.red, textColor: Colors.white),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 22),
                            textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _onButtonPressed('='),
                          child: const Text('='),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}