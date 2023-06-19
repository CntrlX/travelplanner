import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';

class TravelForm extends StatefulWidget {
  const TravelForm({super.key});

  get onChanged => null;
  static String route = '/TravelForm';

  @override
  _TravelFormState createState() => _TravelFormState();
}

class _TravelFormState extends State<TravelForm> {
  final _formKey = GlobalKey<FormState>();
  bool loading = true;
  String _destination = '';
  String _from = '';
  String _duration = '';
  // String _response = '';
  final chatGpt =
      ChatGpt(apiKey: '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');
  double _value = 1;
  String budgetText = '';
  String text = '';

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
                const Text(
                  'Travel Planner',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'From',
                    hintStyle: const TextStyle(color: Colors.white),
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
                      return 'Please enter where you are from';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _from = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Destination',
                    hintStyle: const TextStyle(color: Colors.white),
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
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Duration of travel',
                    hintStyle: const TextStyle(color: Colors.white),
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
                const SizedBox(height: 32.0),
                Column(
                  children: [
                    const Text(
                      'Budget',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
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
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(
                      loading ? 'Loading...' : 'SUBMIT',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
                _resultCard(MediaQuery.of(context).size),
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

  void gpt() async {
    setState(() {
      loading = true;
    });
    final testPrompt =
        'Consider yourself a travel planner. write a travel itinerary to $_destination from $_from for the duration of $_duration with a $budgetText budget.[null] These are the list of sponsors if any include them in the itinerary. And make sure you have the itinerary only and the total estimate budget in indian rupees.';
    //Future.delayed(const Duration(seconds: 40));
    final testRequest = CompletionRequest(
      model: ChatGptModel.gpt35Turbo,
      messages: [
        Message(
          role: 'user',
          content: testPrompt,
        ),
      ],
      maxTokens: 700,
    );
    final result = await chatGpt.createChatCompletion(testRequest);
    print(result!.choices!.first.message!.content.toString());
    text = result.choices!.first.message!.content.toString();
    setState(() {
      loading = false;
    });
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // TODO: Implement response logic based on the entered destination and duration
      budgetText = _getValueText();
      setState(() {
        loading = true;
      });
      gpt();
      setState(() {
        loading = false;
      });
      // Scroll to the bottom of the screen to show the response
      Future.delayed(const Duration(milliseconds: 500), () {
        // _scrollController.animateTo(
        //   _scrollController.position.maxScrollExtent,
        //   duration: const Duration(milliseconds: 1500),
        //   curve: Curves.easeInOut,
        // );
      });
    }
  }

  Widget _resultCard(Size size) {
    return Visibility(
      visible: text.isNotEmpty,
      child: Container(
        // height: MediaQuery.of(context).size.height * 1,
        // width: MediaQuery.of(context).size.width * 1,
        child: Expanded(
          // Wrap the Text widget inside a ListView widget
          child: ListView(
              controller: _scrollController, // Set the controller
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.grey[800],
                  ),
                  child: Text(
                    text ?? 'Loading...',
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
