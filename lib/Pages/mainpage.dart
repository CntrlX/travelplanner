import 'package:flutter/material.dart';

class TravelForm extends StatefulWidget {
  get onChanged => null;
  static String route = '/TravelForm';

  @override
  _TravelFormState createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final _formKey = GlobalKey<FormState>();
  String _destination = '';
  String _duration = '';
  String _response = '';
  double _value = 1;

  // Create a ScrollController to control the scrolling of the ListView
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Travel Planner',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your destination';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _destination = value!;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Duration of travel',
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16.0),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the duration of travel';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _duration = value!;
                  },
                ),
                SizedBox(height: 32.0),
                Column(
                  children: [
                    Text(
                      'Budget',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 8.0),
                    Slider(
                      value: _value,
                      min: 1,
                      max: 3,
                      divisions: 2,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          widget.onChanged?.call(_getValueText());
                        });
                      },
                      label: _getValueText(),
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
                SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      primary: Colors.blue,
                    ),
                  ),
                ),
                SizedBox(height: 32.0),
                Visibility(
                  visible: _response.isNotEmpty,
                  child: Container(
                    // height: MediaQuery.of(context).size.height * 1,
                    // width: MediaQuery.of(context).size.width * 1,
                    child: Expanded(
                      // Wrap the Text widget inside a ListView widget
                      child: ListView(
                          controller: _scrollController, // Set the controller
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Colors.grey[800],
                              ),
                              child: Text(
                                _response,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getValueText() {
    switch (_value.toInt()) {
      case 1:
        return 'Low';
      case 2:
        return 'Medium';
      case 3:
        return 'High';
      default:
        return '';
    }
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // TODO: Implement response logic based on the entered destination and duration
      setState(() {
        _response =
            'You are traveling to $_destination for $_duration. Have a safe trip! \n\n day 1 goa beach \n day 2 goa pub \n day 3 malgoa ';
      });

      // Scroll to the bottom of the screen to show the response
      Future.delayed(Duration(milliseconds: 500), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}
