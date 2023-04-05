import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_dart/chapter_11(Firebase)/helpers/if_debugging.dart';
import 'package:rx_dart/chapter_11(Firebase)/typeDefinition.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;
  const NewContactView(
      {Key? key, required this.createContact, required this.goBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstNameController =
        useTextEditingController(text: 'FirstName'.ifDebugging);
    final lastNameController =
        useTextEditingController(text: 'LastName'.ifDebugging);
    final phoneNumberController =
        useTextEditingController(text: '+91 00000 00000'.ifDebugging);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffF9D342),
          leading: IconButton(
            onPressed: goBack,
            icon: const Icon(
              Icons.close,
              color: Color(0xff292826),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                      controller: firstNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'First Name',
                          hintStyle: GoogleFonts.kumbhSans(
                              color: const Color(0xff292826))),
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ), //first name
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
                      controller: lastNameController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Last Name',
                          hintStyle: GoogleFonts.kumbhSans(
                              color: const Color(0xff292826))),
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
                      controller: phoneNumberController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          hintStyle: GoogleFonts.kumbhSans(
                              color: const Color(0xff292826))),
                      keyboardAppearance: Brightness.dark,
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ), //phone number
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      final firstName = firstNameController.text;
                      final lastName = lastNameController.text;
                      final phoneNumber = phoneNumberController.text;

                      createContact(firstName, lastName, phoneNumber);
                      goBack();

                    },
                  style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xffF9D342))),
                    child: Text('Save Contact',
                        style: GoogleFonts.kumbhSans(
                            color: const Color(0xff292826))),
                )
              ],
            ),
          ),
        ));
  }
}

/*

platform :osx, '10.11'
ENV['COCOAPODS_DISABLE_STATS'] = 'true'
project 'Runner', {
 'Debug' => :debug,
 'Profile' => :release,
 'Release' => :release,
}
def flutter_root
generated_xcode_build_settings_path =
File.expand_path(File.join('..', 'Flutter', 'ephemeral',
'Flutter-
Generated.xcconfig'), __FILE__)
unless File.exist?(generated_xcode_build_settings_path)
  raise "#{generated_xcode_build_settings_path} must exist. If
you're running pod install manually, make sure \"flutter pub
get\"
is
executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
     matches = line.match(/FLUTTER_ROOT\=(.*)/)
     return matches[1].strip if matches
   end
   raise "FLUTTER_ROOT not found in #.
{generated_xcode_build_settings_path}. Try deleting Flutter-
Generated.xcconfig, then run \"flutter pub get\""
end

require File.expand_path(File.join('packages', 'flutter_tools',
'bin', 'podhelper'), flutter_root)

flutter_macos_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_macos_pods
File.dirname(File.realpath(__FILE__))
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_macos_build_settings(target)
  end
end

* */
