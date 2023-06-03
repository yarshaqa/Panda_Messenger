import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panda_messenger/auth_repository.dart';
import 'package:panda_messenger/ui/home_screen/home_cubit.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_cubit.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_screen.dart';
import 'package:panda_messenger/user_repository.dart';
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
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => AuthRepository()),
        RepositoryProvider(create: (context) => UserRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
              create: (BuildContext context) => AuthCubit()),
          BlocProvider<HomeCubit>(
              create: (BuildContext context) =>
                  HomeCubit(authRepository: context.read<AuthRepository>()))
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'OpenSans',
                primaryColor: Color(0xFF6103EE),
                colorScheme: ThemeData()
                    .colorScheme
                    .copyWith(primary: Color(0xFF6103EE)),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: Color(0xFF6103EE))
                // buttonTheme: const ButtonThemeData(buttonColor: Color(0x6103EE)),
                // elevatedButtonTheme: ElevatedButtonThemeData(
                //   style: ButtonStyle(
                //     backgroundColor: MaterialStateProperty.all<Color>(
                //       Colors.deepPurple,
                //     ), //button color
                //     foregroundColor: MaterialStateProperty.all<Color>(
                //       Color(0x6103EE),
                //     ), //text (and icon)
                //   ),
                // )
                // primarySwatch: MaterialColor(0xFF6103EE,)
                ),
            home: Scaffold(body: Material(child: AuthScreen()))),
      ),
    );
  }
}
