import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda_messenger/auth_repository.dart';
import 'package:panda_messenger/ui/general_widgets.dart';
import '../home_screen/home_cubit.dart';
import '../home_screen/home_screen_widget.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({Key? key}) : super(key: key);
  late final AuthRepository authRepository;
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return Scaffold(
        body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: [
          sctructure(context, 'Sign in', controller),
          sctructure(context, 'Sign up', controller)
        ]));
  }

  Widget sctructure(
      BuildContext context, String page, PageController controller) {
    return BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
      if (state is AuthErrorState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.errorMessage)));
      }
      if (state is AuthLoadedState) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen()),);
      }
    }, builder: (BuildContext context, state) {
      if (state is AuthInitialState || state is AuthErrorState) {
        return (Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: MediaQuery.of(context).size.width,
                  child: ClipPath(
                      clipper: CurveClipper(),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                      ))),
              Positioned(
                  left: 30,
                  top: 60,
                  child: Text(
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontSize: 25),
                      page!)),
              Positioned(
                right: 30,
                top: 90,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                    ),
                    onPressed: () {
                      controller.animateToPage(page == 'Sign in' ? 1 : 0,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    },
                    child: Text(
                      page == 'Sign in' ? 'Sign up >' : '< Sign In',
                      style: const TextStyle(
                          fontSize: 25, fontStyle: FontStyle.italic),
                    )),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              child: Column(
                children: [
                  GeneralWidgets.textFieldWithIconGeneral(
                      hintText: 'Email',
                      icon: Icons.email_sharp,
                      text: _textEmailController),
                  GeneralWidgets.textFieldWithIconGeneral(
                      hintText: '00000000',
                      icon: Icons.lock,
                      text: _textPasswordController),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(21.0),
              child: ElevatedButton(
                onPressed: () {
                  if (page == 'Sign up') {
                    context.read<AuthCubit>().signUpWithEmail(
                        userEmail: _textEmailController.text.trim(),
                        userPassword: _textPasswordController.text.trim());
                  } else {
                    context.read<AuthCubit>().signInWithEmail(
                        userEmail: _textEmailController.text.trim(),
                        userPassword: _textPasswordController.text.trim());
                  }
                },
                child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 10,
                    child: Center(child: Text(page.toUpperCase()))),
              ),
            ),
          ],
        ));
      }
      {
        return const Center(
          child: Text('Unknown State'),
        );
      }
    });
  }
}

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;

    return Path()
      ..moveTo(0, 0)
      ..lineTo(0, 180)
      ..cubicTo(width * 0.35, height / 3.5, width * 0.5, height * 1, width, 0)
      ..lineTo(width, 0)
      ..lineTo(0, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
