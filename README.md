# glissando

Slide across widgets while the pointer is down.

<img src="https://github.com/roscale/glissando/blob/master/doc/keyboard_slide.gif?raw=true" />

## Usage

Wrap your widget in a `Glissando`.

```dart
import 'package:flutter/material.dart';
import 'package:glissando/glissando.dart';

void main() {
  runApp(MaterialApp(
    home: Glissando(
      child: Row(
        children: [
          Listener(
            onPointerDown: (_) => print("1 down"),
            onPointerCancel: (_) => print("1 cancel"),
            onPointerUp: (_) => print("1 up"),
            child: Container(
              color: Colors.red,
              width: 100,
              height: 100,
            ),
          ),
          Listener(
            onPointerDown: (_) => print("2 down"),
            onPointerCancel: (_) => print("2 cancel"),
            onPointerUp: (_) => print("2 up"),
            child: Container(
              color: Colors.blue,
              width: 100,
              height: 100,
            ),
          ),
        ],
      ),
    ),
  ));
}
```

When you slide from widget A to widget B, widget A will receive a pointer cancel
event, while widget B will receive a pointer down event.

When you lift the pointer, the widget that last got the down event will get the pointer up event.
