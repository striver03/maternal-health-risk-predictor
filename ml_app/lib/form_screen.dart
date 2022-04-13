import 'package:flutter/material.dart';

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

  Container _buildInputs(
    String heading,
    TextEditingController controller,
    double breadth,
  ) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 60,
        width: breadth,
        child: TextFormField(
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            hintText: heading,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maternal Health Risk Predictor"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  _buildInputs(
                    "Age",
                    _ageController,
                    deviceSize.width * 0.8,
                  ),
                  _buildInputs(
                    "Systolic BP",
                    _systolicBPController,
                    deviceSize.width * 0.8,
                  ),
                  _buildInputs(
                    "Diastolic BP",
                    _diastolicBPController,
                    deviceSize.width * 0.8,
                  ),
                  _buildInputs(
                    "Blood Sugar",
                    _bloodSugarController,
                    deviceSize.width * 0.8,
                  ),
                  _buildInputs(
                    "Body Temperature (in F)",
                    _bodyTempController,
                    deviceSize.width * 0.8,
                  ),
                  _buildInputs(
                    "Heart Rate",
                    _heartRateController,
                    deviceSize.width * 0.8,
                  ),
                ],
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
                  "Predict",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    content: Text("data"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
