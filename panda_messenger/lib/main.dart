import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panda_messenger/ui/home_screen/home_cubit.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_cubit.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_screen.dart';
import 'firebase_options.dart';
import 'internet_connection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final NetworkConnectivity connectivity = NetworkConnectivity.instance;
  connectivity.initialise();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (BuildContext context) => HomeCubit())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
          ),
          home: Material(child: AuthScreen())),
    );
  }
}
