import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panda_messenger/ui/home_screen/home_cubit.dart';
import 'package:panda_messenger/ui/home_screen/home_state.dart';
import 'package:panda_messenger/ui/my_message.dart';
import 'package:panda_messenger/ui/sign_up_sign_in/auth_screen.dart';
import 'package:panda_messenger/user_repository.dart';

import '../../models/message_model.dart';
import '../general_widgets.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController myMessageController = TextEditingController();
  bool isDisplayedTypeMessage = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).messagesStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('isDisplayedTypeMessage $isDisplayedTypeMessage');
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
            child: Icon(Icons.add)),
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
                    style: TextStyle(color: Colors.white),
                  )),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.09,
                right: 30,
                child: IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().logOutUser();
                  },
                  icon: const Icon(Icons.logout_sharp, color: Colors.white),
                ),
              )
            ],
          ),
          BlocConsumer<HomeCubit, HomeStates>(
              listener: (context, state) {
                if(state is HomeLogOutState){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AuthScreen()),);
                }
              },
              builder: (context, state) {
                print('STATE $state');
                if (state is HomeLoadedState) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
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
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.68,
                                  child: messages(context, state))),
                          typeMessage(context, state),
                        ],
                      ),
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
    print('messages ${state.messagesList}');
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      reverse: true,
      itemCount: state.messagesList.length - 1,
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
              contentPadding: EdgeInsets.only(top: 15),
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
                        print('tapped ${myMessageController.text}');
                        // if (myMessageController.text != '') {
                        //   _scrollController.animateTo(
                        //       _scrollController.position.minScrollExtent,
                        //       duration: const Duration(seconds: 1),
                        //       curve: Curves.easeInOut);
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
