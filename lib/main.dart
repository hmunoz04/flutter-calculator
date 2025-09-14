import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

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
        if (_expression.isNotEmpty && !_hasResult) {
          _expression += '^2';
        } else if (_hasResult && _result.isNotEmpty && _result != 'Error') {
          _expression = '$_result^2';
          _result = '';
          _hasResult = false;
        }
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

  void _evaluate() {
    try {
      final exp = Expression.parse(
        _expression
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('%', '%'),
      );
      final evaluator = const ExpressionEvaluator();
      final context = <String, dynamic>{};
      final evalResult = evaluator.eval(exp, context);
      _result = evalResult.toString();
      _expression = '$_expression = $_result';
      _hasResult = true;
    } catch (e) {
      _result = 'Error';
      _expression = '';
      _hasResult = true;
    }
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
                    _buildButton('%', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                    _buildButton('+', color: Colors.blueGrey[200], textColor: Colors.blueGrey[900]),
                  ],
                ),
                Row(
                  children: [
                    _buildButton('x²', color: Colors.orange[200], textColor: Colors.orange[900]),
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