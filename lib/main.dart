import 'package:map_to_najot/bloc/yandexmap_bloc.dart';
import 'package:map_to_najot/pages/map_ui.dart';
import 'package:map_to_najot/permission/permisson.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await permish();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => YandexMapBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GoToDestination(),
      ),
    );
  }
}