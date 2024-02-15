import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:map_to_najot/bloc/yandexmap_bloc.dart'; // Ensure this import matches your project structure
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GoToDistination extends StatefulWidget {
  const GoToDistination({super.key});

  @override
  State<GoToDistination> createState() => _GoToDistinationState();
}

class _GoToDistinationState extends State<GoToDistination> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
    location.onLocationChanged.listen((event) {
      context.read<YandexMapBloc>().add(StartedBloc());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<YandexMapBloc, YandexMapState>(
      builder: (context, state) {
        return Builder(builder: (context) {
          if (state.status == Status.loading) {
            return const CupertinoActivityIndicator();
          } else if (state.status == Status.succses) {
            String distanceText = state.distance != null
                ? 'Manzilga: ${state.distance!.toStringAsFixed(2)} km qoldi'
                : 'Calculating distance...';
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 200),
                child: Column(
                  children: [
                    Expanded(
                      child:Container(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width * 0.95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blueGrey[100]!, Colors.blueGrey[300]!],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: YandexMap(
                            mapObjects: [
                              CircleMapObject(
                                fillColor: Colors.red.withOpacity(0.5),
                                mapId: const MapObjectId("source"),
                                circle: Circle(
                                  center: state.myPoint,
                                  radius: 20,
                                ),
                              ),
                              state.route,
                            ],
                            onMapCreated: (controller) async {
                              await controller.moveCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    zoom: 17,
                                    target: state.myPoint,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: 400,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        distanceText,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Scaffold();
          }
        });
      },
    );
  }
}
