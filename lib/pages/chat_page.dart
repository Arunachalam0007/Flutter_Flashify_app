// Packages
import 'package:flashify_app/models/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/chat_page_provider.dart';

// Models
import '../models/chat.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_field.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  ChatPage({required this.chat});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;

  late GlobalKey<FormState> _messageFormState;
  late ScrollController _messageScrollListViewController;

  late ChatPageProvider _pageProvider;

  @override
  void initState() {
    super.initState();
    _messageFormState = GlobalKey<FormState>();
    _messageScrollListViewController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatPageProvider>(
          create: (_) => ChatPageProvider(
            widget.chat.uid,
            _auth,
            _messageScrollListViewController,
          ),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (_context) {
        _pageProvider = _context.watch<ChatPageProvider>();
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02,
              ),
              height: _deviceHeight,
              width: _deviceWidth * 0.97,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _chatPageTopBar(),
                  _messageListView(),
                  _sendMessageForm(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _chatPageTopBar(){
    return TopBar(
      widget.chat.title(),
      titleFontSize: 20,
      primaryAction: IconButton(
        icon: const Icon(Icons.arrow_back),
        color: const Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _pageProvider.goBack();
        },
      ),
      secondarAction: IconButton(
        icon: const Icon(Icons.delete),
        color: const Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _pageProvider.deleteChat();
        },
      ),
    );
  }

  Widget _messageListView() {
    if (_pageProvider.messages != null) {
      if (_pageProvider.messages!.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            controller: _messageScrollListViewController,
              itemCount: _pageProvider.messages!.length,
              itemBuilder: (_context, int itemIndex) {
                ChatMessage _message = _pageProvider.messages![itemIndex];
                bool _isOwnMessage = _message.senderId == _auth.chatUser.uid;
                return SizedBox(
                  // height: _deviceHeight * 0.74,
                  child: CustomChatListViewTile(
                    width: _deviceWidth,
                    deviceHeight: _deviceWidth,
                    isOwnMessage: _isOwnMessage,
                    message: _message,
                    sender: widget.chat.members
                        .where((_mem) => _mem.uid == _message.senderId)
                        .first,
                  ),
                );
              }),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the First to Say Hi!!!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    }
  }

  Widget _sendMessageForm() {
    return Container(
      height: _deviceHeight * 0.07,
      decoration: BoxDecoration(
        color: Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03,
      ),
      child: Form(
        key: _messageFormState,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _formMessageTextField(),
            _formSendMessageBtn(),
            _formImageSendBtn(),
          ],
        ),
      ),
    );
  }

  Widget _formMessageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
        hintText: 'Type a Message',
        icon: Icons.keyboard,
        obscureText: false,
        onSaved: (_val) {
          _pageProvider.message = _val;
        },
        regEx: r"^(?!\s*$).+",
      ),
    );
  }

  Widget _formSendMessageBtn() {
    double _size = _deviceHeight * 0.04;

    return Container(
      width: _size,
      height: _size,
      child: IconButton(
        icon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
        onPressed: () {
          if(_messageFormState.currentState!.validate()){
            _messageFormState.currentState!.save();
            _pageProvider.sendTextMessage();
            _messageFormState.currentState!.reset();
          }
        },
      ),
    );
  }

  Widget _formImageSendBtn() {
    double _size = _deviceHeight * 0.04;
    return Container(
      width: _size,
      height: _size,
      child: FloatingActionButton(
        child: const Icon(
          Icons.camera_enhance,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _pageProvider.sendImageFile();
        },
      ),
    );
  }
}
