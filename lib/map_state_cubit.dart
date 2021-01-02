import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';

class MapStateCubit extends Cubit<double> {
  MapController controller;
  MapStateCubit(this.controller) : super(13.0);

  void zoomIn() {
    final zoomLevel = controller.zoom + 1.0;
    controller.move(controller.center, zoomLevel);
    emit(zoomLevel);
  }

  void zoomOut() {
    final zoomLevel = controller.zoom - 1.0;
    controller.move(controller.center, zoomLevel);
    emit(zoomLevel);
  }
}
