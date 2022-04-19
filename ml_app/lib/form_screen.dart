import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    IconData icon,
    String heading,
    String unit,
    TextEditingController controller,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          FaIcon(icon),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
              decoration: InputDecoration(
                hintText: heading,
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
      String result = responseData['RiskLevel'].toString();
      if (result == "['low risk']") {
        result = "Low Risk";
      } else if (result == "['mid risk']") {
        result = "Mid Risk";
      } else {
        result = "High Risk";
      }
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color.fromRGBO(255, 254, 229, 1),
          content: Row(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(10),
                child: const Text(
                  "Risk Level -",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Text(
                result,
                style: const TextStyle(fontSize: 20),
              ),
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
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    width: 250,
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: const FaIcon(FontAwesomeIcons.userDoctor),
                        ),
                        const Spacer(),
                        const Text(
                          "Enter Details",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Form(
                      key: _form,
                      child: ListView(
                        children: <Widget>[
                          _buildInputs(
                            FontAwesomeIcons.userNurse,
                            "Age",
                            "",
                            _ageController,
                          ),
                          _buildInputs(
                            FontAwesomeIcons.pumpMedical,
                            "Systolic BP",
                            "mmHg",
                            _systolicBPController,
                          ),
                          _buildInputs(
                            FontAwesomeIcons.pumpMedical,
                            "Diastolic BP",
                            "mmHg",
                            _diastolicBPController,
                          ),
                          _buildInputs(
                            FontAwesomeIcons.fileWaveform,
                            "Blood Sugar",
                            "mmol/L",
                            _bloodSugarController,
                          ),
                          _buildInputs(
                            FontAwesomeIcons.thermometer,
                            "Body Temperature",
                            "F",
                            _bodyTempController,
                          ),
                          _buildInputs(
                            FontAwesomeIcons.heartPulse,
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
                      color: Colors.pink,
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
