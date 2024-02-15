part of 'yandexmap_bloc.dart';

class YandexMapState {
  final Point distination;
  final Point myPoint;
  final PolylineMapObject route;
  final Status status;
  final double? distance;
  YandexMapController? controller;
  YandexMapState({
    required this.distination,
    required this.myPoint,
    this.controller,
   required this.route,
    required this.status,
    required this.distance,
  });
  YandexMapState copyWith({
    Point? distination,
    Point? myPoint,
    PolylineMapObject? route,
    Status? status,
    double? distance,
    YandexMapController? controller,
  }) {
    return YandexMapState(
      distination: distination ?? this.distination,
      myPoint: myPoint ?? this.myPoint,
      controller: controller ?? this.controller,
      route: route ?? this.route,
      status: status ?? this.status,
      distance: distance ?? this.distance,
    );
  }
 }
 enum Status{
  loading, succses,
 }