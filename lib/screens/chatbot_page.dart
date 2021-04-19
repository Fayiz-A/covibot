import 'package:covibot/blocs/chatbot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {

  TextEditingController queryTextFormFieldController = TextEditingController(text: 'Hey');

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('CoviBot'),
      ),
      body: Column(
        children: [
          // Expanded(
          //   child: ElevatedButton(
          //     child: Text('Send some message to Chatbot'),
          //     onPressed: () {
          //
          //       ChatbotBloc chatbot = BlocProvider.of<ChatbotBloc>(context);
          //
          //       chatbot.add(SendQueryEvent(query: 'Hello'));
          //     },
          //   ),
          // ),
          Flexible(
            child: ListView.builder(
                reverse: true,
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      child: Container(
                        width: screenSize.width * 0.8,
                        height: screenSize.height * 0.05,
                        color: Colors.lightBlueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(
                            'Text',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Divider(
            thickness: 1.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ListTile(
              title: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      child: TextFormField(
                        onChanged: (String value) => print(value),
                        style: Theme.of(context).textTheme.bodyText1,
                        decoration: InputDecoration(

                        ),
                        controller: queryTextFormFieldController,
                      ),
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
                        onPressed: () => print('Sending'),
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
