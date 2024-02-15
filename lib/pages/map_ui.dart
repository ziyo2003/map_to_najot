import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:map_to_najot/bloc/yandexmap_bloc.dart'; // Adjust based on your project
import 'package:yandex_mapkit/yandex_mapkit.dart';

class GoToDestination extends StatefulWidget {
  const GoToDestination({Key? key}) : super(key: key);

  @override
  State<GoToDestination> createState() => _GoToDestinationState();
}

class _GoToDestinationState extends State<GoToDestination> {
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
        if (state.status == Status.loading) {
          return const CupertinoActivityIndicator();
        } else if (state.status == Status.succses) {
          String distanceText = state.distance != null
              ? 'Manzilga: ${state.distance!.toStringAsFixed(2)} km qoldi'
              : 'Hissoblanmoqda...';
          return Scaffold(
            backgroundColor: Colors.grey.shade900,
            body: Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 40),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
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
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
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
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      distanceText,
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(body: Center(child: Text('An error occurred')));
        }
      },
    );
  }
}
