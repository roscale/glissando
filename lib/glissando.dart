import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Glissando extends SingleChildRenderObjectWidget {
  const Glissando({super.key, super.child});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _GlissandoRenderBox();
  }
}

class _GlissandoRenderBox extends RenderProxyBox {
  final Map<int, HitTestResult> _previousHitTestResults = {};

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (event is! PointerMoveEvent) {
      super.handleEvent(event, entry);
      return;
    }

    var hitTestResult = BoxHitTestResult();
    hitTestChildren(hitTestResult, position: event.localPosition);

    final previousHitTestResult = _previousHitTestResults.putIfAbsent(event.pointer, () => hitTestResult);

    HitTestTarget? firstTarget(HitTestResult? result) => result?.path.firstOrNull?.target;

    final from = firstTarget(previousHitTestResult);
    final to = firstTarget(hitTestResult);

    if (to != null && from != to) {
      {
        var fake = PointerCancelEvent(pointer: event.pointer);
        GestureBinding.instance.handlePointerEvent(fake);
      }

      var fake = PointerDownEvent(
        timeStamp: event.timeStamp,
        pointer: event.pointer,
        kind: event.kind,
        device: event.device,
        position: event.position,
        buttons: event.buttons,
        obscured: event.obscured,
        pressure: event.pressure,
        pressureMin: event.pressureMin,
        pressureMax: event.pressureMax,
        distanceMax: event.distanceMax,
        size: event.size,
        radiusMajor: event.radiusMajor,
        radiusMinor: event.radiusMinor,
        radiusMin: event.radiusMin,
        radiusMax: event.radiusMax,
        orientation: event.orientation,
        tilt: event.tilt,
        embedderId: event.embedderId,
      );

      Future.microtask(() {
        GestureBinding.instance.handlePointerEvent(fake);
      });
    }
    _previousHitTestResults[event.pointer] = hitTestResult;
  }
}
