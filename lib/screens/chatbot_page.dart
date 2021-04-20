import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:covibot/classes/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  
  TextEditingController queryTextFormFieldController = TextEditingController();

  ChatbotBloc chatBloc;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chatBloc = BlocProvider.of<ChatbotBloc>(context);
  }

  clearTextBoxAndSendQuery({@required String query}) {
    queryTextFormFieldController.clear();

    chatBloc.add(SendQueryEvent(query: query));
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('CoviBot'),
      ),
      body: Column(
        children: [
          Flexible(
            child: BlocBuilder<ChatbotBloc, ChatbotState>(
              builder: (BuildContext context, ChatbotState state) {
                if(state is MessageAddedState) {

                  List<Message> chatList = state.chatList;

                  return ListView.builder(
                      reverse: true,
                      itemCount: chatList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Message message = chatList[index];

                        bool chatbotSender = message.sender == Sender.chatbot;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: chatbotSender ? MainAxisAlignment.start:MainAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                child: chatbotSender ? Icon(Icons.computer):Icon(Icons.person),
                                backgroundColor: Colors.black,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                    width: screenSize.width * 0.7,
                                    color: chatbotSender ? Colors.orangeAccent:Colors.greenAccent,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SelectableText(
                                        chatList[index].message,
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });

                } else {
                  return CircularProgressIndicator();
                }
                // return ListView.builder(
                //     reverse: true,
                //     itemCount: 2,
                //     itemBuilder: (BuildContext context, int index) {
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.all(Radius.circular(20.0)),
                //           child: Container(
                //             width: screenSize.width * 0.8,
                //             height: screenSize.height * 0.05,
                //             color: Colors.lightBlueAccent,
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: SelectableText(
                //                 'Text',
                //                 style: Theme.of(context).textTheme.bodyText1,
                //               ),
                //             ),
                //           ),
                //         ),
                //       );
                //     });
              }
            ),
          ),
          Divider(
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  child: TextFormField(
                    onFieldSubmitted: (String query) => clearTextBoxAndSendQuery(query: query,),//query from text controller will also work fine
                    style: Theme.of(context).textTheme.bodyText1,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Query Here',
                      border: OutlineInputBorder(borderSide: BorderSide(width: 1.0, color: Colors.red, style: BorderStyle.solid ), borderRadius: BorderRadius.all(Radius.circular(20.0)))
                    ),
                    controller: queryTextFormFieldController,
                  ),
                ),
              ),
                trailing: Padding(
                  padding: EdgeInsets.all(4.0),
                  child: ClipOval(
                    child: Tooltip(
                      message: 'Send',
                      preferBelow: false,
                      child: IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 30.0,
                        onPressed: () => clearTextBoxAndSendQuery(query: queryTextFormFieldController.text,),
                      ),
                    )
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}
