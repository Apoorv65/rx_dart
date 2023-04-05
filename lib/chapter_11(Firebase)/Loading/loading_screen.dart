import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rx_dart/chapter_11(Firebase)/Loading/loadingScreenController.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static late final LoadingScreen _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = _showOverlay(context: context, text: text);
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;
    final availableSize = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(100),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: availableSize.width * 0.8,
              maxHeight: availableSize.height * 0.8,
              minWidth: availableSize.width * 0.5,
            ),
            decoration: BoxDecoration(
              color:  const Color(0xff292826),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Color(0xffF9D342),
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder<String>(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.requireData,
                                style: GoogleFonts.kumbhSans(
                                    color:const Color(0xffF9D342)),
                                textAlign: TextAlign.center);
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
                  ),
                )),
          ),
        ),
      );
    });

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        _text.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        _text.add(text);
        return true;
      },
    );
  }
}
