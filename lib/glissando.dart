import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Glissando extends SingleChildRenderObjectWidget {
  final bool enabled;

  const Glissando({
    super.key,
    required super.child,
    this.enabled = true,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return GlissandoRenderBox(
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(BuildContext context, GlissandoRenderBox renderObject) {
    renderObject.enabled = enabled;
  }
}

class GlissandoRenderBox extends RenderProxyBox {
  bool enabled;
  final Map<int, HitTestResult> _previousHitTestResults = {};

  GlissandoRenderBox({
    required this.enabled,
  });

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    if (!enabled || event is! PointerMoveEvent) {
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
      PointerEvent fake = PointerCancelEvent(
        timeStamp: event.timeStamp,
        pointer: event.pointer,
        kind: event.kind,
        device: event.device,
        position: event.position,
        buttons: event.buttons,
        obscured: event.obscured,
        pressureMin: event.pressureMin,
        pressureMax: event.pressureMax,
        distance: event.distance,
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

      GestureBinding.instance.handlePointerEvent(fake);

      fake = PointerDownEvent(
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
