import 'package:dog_picker/DB%20Bloc/db_bloc.dart';
import 'package:dog_picker/Image%20Bloc/image_pick_bloc.dart';
import 'package:dog_picker/View/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DbBloc(),
        ),
        BlocProvider(
          create: (context) => ImagePickBloc(),
        )
      ],
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: HomeScreen(),
      ),
    );
  }
}
