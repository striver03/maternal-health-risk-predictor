import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _ageController = TextEditingController();
  final _systolicBPController = TextEditingController();
  final _diastolicBPController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _bodyTempController = TextEditingController();
  final _heartRateController = TextEditingController();

  final _form = GlobalKey<FormState>();

  var _isLoading = false;

  Container _buildInputs(
    String heading,
    String unit,
    TextEditingController controller,
  ) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(heading),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(unit),
              ),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                gapPadding: 1.0,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty || value.contains('-')) {
                return "Invalid Input";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> _predict() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) return;
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Uri url = Uri.parse(
          "https://maternal-health-risk-predictor.herokuapp.com/predict?age=${_ageController.text}&systolicBP=${_systolicBPController.text}&diastolicBP=${_diastolicBPController.text}&bloodSugar=${_bloodSugarController.text}&bodyTemp=${_bodyTempController.text}&heartRate=${_heartRateController.text}");
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Row(
            children: <Widget>[
              const Text("Risk Level"),
              Text(responseData['RiskLevel']),
            ],
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
        ),
      );
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maternal Health Risk Predictor"),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: <Widget>[
                          _buildInputs(
                            "Age",
                            "",
                            _ageController,
                          ),
                          _buildInputs(
                            "Systolic BP",
                            "mmHg",
                            _systolicBPController,
                          ),
                          _buildInputs(
                            "Diastolic BP",
                            "mmHg",
                            _diastolicBPController,
                          ),
                          _buildInputs(
                            "Blood Sugar",
                            "mmol/L",
                            _bloodSugarController,
                          ),
                          _buildInputs(
                            "Body Temperature",
                            "F",
                            _bodyTempController,
                          ),
                          _buildInputs(
                            "Heart Rate",
                            "BPM",
                            _heartRateController,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0XFFF95C04),
                    ),
                    child: TextButton(
                      child: const Text(
                        "PREDICT",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _predict,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
