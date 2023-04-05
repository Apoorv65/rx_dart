import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_dart/chapter_11(Firebase)/helpers/if_debugging.dart';
import 'package:rx_dart/chapter_11(Firebase)/typeDefinition.dart';

class LoginView extends HookWidget {
  final LoginFunc login;
  final VoidCallback goToRegisterView;
  const LoginView(
      {Key? key, required this.login, required this.goToRegisterView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        useTextEditingController(text: 'abc@xyz.com'.ifDebugging);
    final passwordController =
    useTextEditingController(text: '~~~~~~~~'.ifDebugging);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

          DelayedDisplay(
            slidingBeginOffset: Offset.fromDirection(19),
            child: Text(
              'Login',
              style: GoogleFonts.kumbhSans(
                  color: const Color(0xff292826), fontSize: 60),
            ),
          ),

          const SizedBox(height: 40),

          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: const Color(0xffF9D342),
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email',
                    hintStyle:
                        GoogleFonts.kumbhSans(color: const Color(0xff292826))),
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.name,
              ),
            ),
          ), //last name
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(
                  color: const Color(0xffF9D342),
                ),
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Password',
                    hintStyle:
                        GoogleFonts.kumbhSans(color: const Color(0xff292826))),
                obscureText: true,
                keyboardAppearance: Brightness.dark,
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              final email = emailController.text;
              final password = passwordController.text;
              login(email, password);
            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color(0xffF9D342))),
            child: Text(
              'Login',
              style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
            ),
          ),

          TextButton(
            onPressed: goToRegisterView,
            child: Text(
              'Not registered yet? Register here!',
              style: GoogleFonts.kumbhSans(color: const Color(0xff292826)),
            ),
          )
        ]),
      ),
    );
  }
}
