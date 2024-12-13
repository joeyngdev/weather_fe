import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_forecast/api/firebase_caller.dart';
import 'package:weather_forecast/util/overlay_handler.dart';
import 'package:weather_forecast/widgets/email_overlay.dart';
import 'package:weather_forecast/widgets/icon_button.dart';

class RegisterDailyForecast extends StatelessWidget {
  const RegisterDailyForecast({super.key});

  Future<String> register(String userEmail) async {
    try {
      if (await FirebaseCaller.writeEmail(email: userEmail)) {
        return "An confirmation has been sent to your email. Confirm it if you want to receive daily weather forecast information";
      } else {
        return "This email has subscribed to daily weather forecast service";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'too-many-requests') {
          return "Maybe you are sending too much requests. Please way a few minutes to try again";
        }
      } else {
        return "An error has occured. Please way a few minutes to try again";
      }
    }
    return "default";
  }

  Future<String> unsubcribe(String userEmail) async {
    try {
      if (await FirebaseCaller.unsubcribe(email: userEmail)) {
        return "You have unsubcribed the service";
      } else {
        return "This email isn't registered to the service";
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'too-many-requests') {
          return "Maybe you are sending too much requests. Please way a few minutes to try again";
        }
      } else {
        return "An error has occured. Please way a few minutes to try again";
      }
    }
    return "default";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CustomIconButton(
              icon: Icons.subscriptions,
              title: "Subscribe",
              onPress: () {
                OverlayHandler().show(
                    context,
                    EmailOverlay(
                      handleEmail: register,
                      isSubscribe: true,
                    ));
              },
              color: Colors.green[400]!,
            ),
          ),
        ),
        Expanded(
          child: CustomIconButton(
            icon: Icons.unsubscribe,
            title: "Unsubscribe",
            onPress: () {
              OverlayHandler().show(
                  context,
                  EmailOverlay(
                    handleEmail: unsubcribe,
                    isSubscribe: false,
                  ));
            },
            color: Colors.red[400]!,
          ),
        ),
      ],
    );
  }
}
