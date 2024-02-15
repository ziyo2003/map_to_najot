import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'yandexmap_event.dart';
part 'yandexmap_state.dart';

class YandexMapBloc extends Bloc<MapEvent, YandexMapState> {
  YandexMapBloc() : super(
          YandexMapState(route: const PolylineMapObject(mapId: MapObjectId('route'), polyline: Polyline(points: []),),
            status: Status.loading,
            distination: const Point(latitude: 41.285703, longitude: 69.203733),
            myPoint: const Point(latitude: 0, longitude: 0), distance: null,
          ),
        ){
    on<StartedBloc>((event, emit) async {
      var point = await Location().getLocation();
      double distance = calculateDistance(
        point.latitude!,
        point.longitude!,
        state.distination.latitude,
        state.distination.longitude,
      );
      emit(state.copyWith(
        myPoint: Point(latitude: point.latitude!, longitude: point.longitude!),
        status: Status.succses,
        distance: distance,
      ));
      final request = YandexDriving.requestRoutes(
        points: [
          RequestPoint(
            point: state.myPoint,
            requestPointType: RequestPointType.wayPoint,
          ),
          RequestPoint(
            point: state.distination,
            requestPointType: RequestPointType.wayPoint,
          ),
        ],
        drivingOptions: const DrivingOptions(
          initialAzimuth: 0,
          routesCount: 1,
          avoidTolls: true,
        ),
      );
      final result = await request.result;

      emit(state.copyWith(
        route: PolylineMapObject(
          strokeColor: Colors.green,
          strokeWidth: 2.5,
          mapId: const MapObjectId("route"),
          polyline: Polyline(
            points: result.routes?.first.geometry ?? [],
          ),
        ),
      ));
    });
  }
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }
}

