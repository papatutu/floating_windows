A widget wrapper that allows a floating windows be dragged and rescaled.

## Features

- Floating widget on top of the screen
- Resizing and repositioning the floating widget
- Constrainable space to float inside the tree (optional)
- Limiting borders with padding
- State managment when pushing and poping screens (needs the RouteObserver for managing push)

![FloatingWindows](https://github.com/user-attachments/assets/0525ffb6-3512-4282-b302-473cc028cf44)

## Getting started

Add to your ```pubspec.yaml``` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  floating_windows: ^1.0.0
```

Import the package

```dart
import 'package:floating_windows/floating_windows.dart';
```

## Usage

Create a FloatingOverlayController

```dart
final controller1 = FloatingOverlayController.absoluteSize(
  maxSize: const Size(800, 800),
  minSize: const Size(400, 300),
  start: Offset.zero,
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
final controller2 = FloatingOverlayController.absoluteSize(
  maxSize: const Size(800, 800),
  minSize: const Size(400, 300),
  start: const Offset(100, 100),
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
final controller3 = FloatingOverlayController.absoluteSize(
  maxSize: const Size(800, 800),
  minSize: const Size(300, 500),
  start: const Offset(300, 300),
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
```

or

```dart
final controller = FloatingOverlayController.relativeSize(
  maxScale: 2.0,
  minScale: 1.0,
  start: Offset.zero,
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
```

Insert the FloatingOverlay widget inside your widget tree and give it the controller, a child and floatingChildren.

```dart
FloatingOverlay(
  controllers: [controller1, controller2, controller3],
  floatingChildren: [
    SizedBox(
      width: 400,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
            color: Colors.black,
            width: 5.0,
          ),
        ),
      ),
    ),
    SizedBox(
      width: 400,
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          border: Border.all(
            color: Colors.black,
            width: 5.0,
          ),
        ),
      ),
    ),
    SizedBox(
      width: 300,
      height: 500,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(
            color: Colors.black,
            width: 5.0,
          ),
        ),
      ),
    ),
  ],
  child: Container(),
)
```

Then use the controller to make the floating child show or hide.

```dart
controller.hide();
controller.isFloating;
controller.show();
controller.toggle();
```
