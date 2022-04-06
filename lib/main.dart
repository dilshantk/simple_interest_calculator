import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SICalculator(),
      theme: ThemeData(
        primaryColor: Colors.indigo,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.indigoAccent),
      ),
    );
  }
}

class SICalculator extends StatefulWidget {
  const SICalculator({Key? key}) : super(key: key);

  @override
  State<SICalculator> createState() => _SICalculatorState();
}

class _SICalculatorState extends State<SICalculator> {
  var formKey = GlobalKey<FormState>();
  String currentSelected = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentSelected = currency[0];
  }

  var currency = ["Rupees", "Dollar", "Dinar"];
  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();
  String displayResult = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(
              height: 60,
            ),
            getImageAsset(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (String? value) {
                  if (_isNumeric(value!)) {
                    return "Please enter principal amount";
                  }
                },
                controller: principalController,
                decoration: InputDecoration(
                    labelText: "Principal",
                    hintText: "Enter Principal eg:12000",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                validator: (String? value) {
                  if (_isNumeric(value!)) {
                    return "Please enter rate of interest";
                  }
                },
                controller: roiController,
                decoration: InputDecoration(
                    labelText: "Interest Rate",
                    hintText: "In Percent",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (String? value) {
                        if (_isNumeric(value!)) {
                          return "Please enter term years";
                        }
                      },
                      controller: termController,
                      decoration: InputDecoration(
                          labelText: "Term",
                          hintText: "Time in Years",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                        items: currency.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: currentSelected,
                        onChanged: (String? newValueSelected) {
                          onDropDownItemSelected(newValueSelected!);
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (formKey.currentState!.validate()) {
                                this.displayResult = calculateTotalReturns();
                              }
                            });
                          },
                          child: Text("Calculate"))),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              reset();
                            });
                          },
                          child: Text("Reset"))),
                ],
              ),
            ),
            Center(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(displayResult,style: TextStyle(fontSize: 25),),
            ))
          ],
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/rupees.png");
    Image image = Image(
      image: assetImage,
      width: 125,
      height: 125,
    );
    return Container(
      child: image,
    );
  }

  void onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentSelected = newValueSelected;
    });
  }

  String calculateTotalReturns() {
    double principal = double.parse(principalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);
    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result =
        "After $term years, your investment will be worth $totalAmountPayable";
    return result;
  }

  void reset() {
    principalController.text = "";
    roiController.text = "";
    termController.text = "";
    displayResult = "";
    currentSelected = currency[0];
  }

  bool _isNumeric(String result) {
    if (result == null) {
      return true;
    }
    return double.tryParse(result) == null;
  }
}
