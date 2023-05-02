import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:panda_messenger/ui/home_screen/home_cubit.dart';
import 'package:panda_messenger/ui/home_screen/home_state.dart';
import 'package:panda_messenger/ui/my_message.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_screen.dart';
import 'package:panda_messenger/user_repository.dart';

import '../../models/message_model.dart';
import '../general_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController myMessageController = TextEditingController();
  bool isDisplayedTypeMessage = false;

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).messagesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: !isDisplayedTypeMessage,
        child: FloatingActionButton(
            onPressed: () {
              if (!isDisplayedTypeMessage) {
                isDisplayedTypeMessage = true;
                setState(() {});
              }
            },
            child: const Icon(Icons.add)),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(children: [
          Stack(
            children: [
              Positioned(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.16,
                width: MediaQuery.of(context).size.width,
                child: const ColoredBox(color: Colors.deepPurple),
              )),
              Positioned(
                  top: MediaQuery.of(context).size.height * 0.11,
                  left: 25,
                  child: Text(
                    UserRepository.userRepository.getUserEmail,
                    style: const TextStyle(color: Colors.white),
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.09,
                right: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: () {
                        BlocProvider.of<HomeCubit>(context).logOutUser();
                      },
                      icon: const Icon(FontAwesomeIcons.doorOpen,
                          color: Colors.deepPurple),
                    ),
                  ),
                ),
              )
            ],
          ),
          BlocConsumer<HomeCubit, HomeStates>(listener: (context, state) {
            if (state is HomeLogOutState) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AuthScreen()),
              );
            }
            if (state is HomeErrorState) {
              GeneralWidgets.defaultToastSnackBar(context, state.errorMessage);
            }
          }, builder: (context, state) {
            if (state is HomeLoadedState) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    GeneralWidgets.textFieldGeneral("Search"),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.66,
                            child: messages(context, state))),
                    typeMessage(context, state),
                  ],
                ),
              );
            } else {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text('No messages yet in chat..'),
                    Container(child: typeMessage(context, state))
                  ]);
            }
          })
        ]),
      ),
    );
  }

  Widget messages(BuildContext context, state) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      reverse: true,
      itemCount: state.messagesList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 100,
            child: MessageCard(
              messageModel: state.messagesList[index],
            ),
          ),
        );
      },
    );
  }

  Widget typeMessage(BuildContext context, state) {
    return Visibility(
      visible: isDisplayedTypeMessage,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextFormField(
            maxLines: 5,
            minLines: 1,
            controller: myMessageController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 15),
              border: InputBorder.none,
              hintText: 'Type Your Message',
              hintStyle: const TextStyle(color: Colors.grey),
              prefix: const SizedBox(
                width: 20,
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        MessageModel message = MessageModel(
                          message: myMessageController.text,
                          time: DateTime.now().toString(),
                        );
                        context.read<HomeCubit>().sendMessage(message);
                        myMessageController.clear();
                        // }
                        isDisplayedTypeMessage = false;
                        setState(() {});
                      },
                      child: const SizedBox(
                          width: 50, height: 50, child: Icon(Icons.send)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
