import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/riverpod/loading_provider.dart';
import 'package:weather_forecast/widgets/backdrop.dart';
import 'package:weather_forecast/widgets/button.dart';

class EmailOverlay extends ConsumerStatefulWidget {
  const EmailOverlay(
      {super.key, required this.isSubscribe, required this.handleEmail});
  final bool isSubscribe;
  final Future<String> Function(String) handleEmail;
  @override
  ConsumerState<EmailOverlay> createState() => _EmailOverlayState();
}

class _EmailOverlayState extends ConsumerState<EmailOverlay> {
  bool isVibility = true;
  var userEmail = "", emailStatus = "";
  final _formKey = GlobalKey<FormState>();

  void sendEmail() async {
    ref.read(loadingProvider.notifier).changeState();
    String message = await widget.handleEmail(userEmail);
    ref.read(loadingProvider.notifier).changeState();
    setState(() {
      emailStatus = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Backdrop(
      isVisibility: isVibility,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.3,
          heightFactor: 0.3,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: widget.isSubscribe ? Colors.blue[100] : Colors.red[100]),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter your email",
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      onSaved: (newValue) => userEmail = newValue!,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Enter your email first";
                        }
                        final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                        if (!emailRegExp.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      style: TextStyle(
                          fontSize:
                              14 * MediaQuery.textScalerOf(context).scale(1)),
                      decoration: InputDecoration(
                        hintText: "Eg: abc@gmail.com",
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 43, 243, 226),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Button(
                      title: "Submit",
                      onPress: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          sendEmail();
                        }
                      },
                      color: widget.isSubscribe ? Colors.blue : Colors.red,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ref.watch(loadingProvider)
                        ? const CircularProgressIndicator()
                        : Expanded(
                            child: Text(
                              overflow: TextOverflow.clip,
                              emailStatus,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
