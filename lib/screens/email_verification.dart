import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';

import '../constants/constant.dart';

class EmailVerification extends StatefulWidget {
  final String emailAddress;

  const EmailVerification({super.key, required this.emailAddress});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController otpController = TextEditingController();
  String currentText = "";

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(appIcon),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Email Verification",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                  fontSize: 16),
            ),
            const Text("Enter the 6 digit code sent to your email address"),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 6,
                obscureText: true,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                validator: (v) {
                  if (v!.length < 5) {
                    return "Please fill in the code";
                  } else {
                    return null;
                  }
                },
                pinTheme: PinTheme(
                  inactiveFillColor: secondaryColor,
                  inactiveColor: secondaryColor,
                  selectedColor: brandColor,
                  selectedFillColor: brandColor,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: otpController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 10,
                  )
                ],
                onCompleted: (v) async {
                  await ParkingRepository().verifyOTP(
                      widget.emailAddress, otpController.text, context);
                },
                onChanged: (value) {
                  setState(() {
                    currentText = value;
                  });
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
            ),
            Row(
              children: [
                const Text("Didn’t get any email?"),
                TextButton(
                    onPressed: () async {
                      await ParkingRepository().resendOTP(context);
                    },
                    child: const Text(
                      "Resend code",
                      style: TextStyle(
                          color: secondaryColor, fontWeight: FontWeight.bold),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
