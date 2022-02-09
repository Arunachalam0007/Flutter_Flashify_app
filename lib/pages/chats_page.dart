// Packages
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Pages
import '../pages/chat_page.dart';
// Providers

import '../providers/authentication_provider.dart';
import '../providers/chats_page_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

// Services
import '../services/navigation_service.dart';

// Models
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../models/chat_user.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<ChatsPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatsPageProvider _pageProvider;
  late NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navigationService =  GetIt.instance.get<NavigationService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (_context) {
        // This will Re-Render when ChatsPageProvider got updated
        _pageProvider = _context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _topBar(),
              _chatList(),
            ],
          ),
        );
      },
    );
  }

  TopBar _topBar() {
    return TopBar(
      'Chats',
      secondarAction: IconButton(
        icon: Icon(Icons.logout),
        color: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: () {
          _auth.logout();
          _navigationService.popAndNavigateToRoute('/login');
        },
      ),
    );
  }

  Widget _chatList() {
    List<Chat>? _chats = _pageProvider.chats;

    return Expanded(
      child: (() {
        if (_chats != null) {
          if (_chats.isNotEmpty) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (_context, _index) {
                return _chatListTile(_chats[_index]);
              },
            );
          } else {
            return const Center(
                child: Text(
              'No Chats Found...',
              style: TextStyle(
                color: Colors.white,
              ),
            ));
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      })(),
    );
  }

  Widget _chatListTile(Chat _chat) {
    List<ChatUser> _receptients = _chat.recepients();
    bool _isActive = _receptients.any((user) => user.wasRecentlyActive());
    String _subtitleText = '';
    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachment"
          : _chat.messages.first.content;
    }
    return CustomListViewTileWithActivity(
      title: _chat.title(),
      subTtile: _subtitleText,
      onTap: () {
        _navigationService.navigateToPage(ChatPage(chat: _chat));
      },
      imageURL: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      height: _deviceHeight * 0.10,
    );
  }
}
