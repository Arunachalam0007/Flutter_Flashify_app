//Packages
import 'package:flashify_app/models/chat_user.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

// Provider
import '../providers/authentication_provider.dart';
import '../providers/users_page_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late UsersPageProvider _usersPageProvider;
  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (_context) {
        _usersPageProvider = _context.watch<UsersPageProvider>();
        return Container(
          height: _deviceHeight * 0.98,
          width: _deviceWidth * 0.97,
          padding: EdgeInsets.symmetric(
            horizontal: _deviceWidth * 0.03,
            vertical: _deviceHeight * 0.02,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TopBar(
                'Users',
                secondarAction: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                  onPressed: () {
                    _auth.logout();
                  },
                ),
              ),
              CustomTextField(
                obscureText: false,
                hintText: 'Search...',
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
                onEditingComplete: (_val) {
                  _usersPageProvider.getUsers(userName: _val);
                  //  FocusScope.of(context).unfocus();
                },
              ),
              _userList(),
              _createChatBtn(),
            ],
          ),
        );
      },
    );
  }

  Widget _userList() {
    List<ChatUser>? _users = _usersPageProvider.listOfUsers;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.isNotEmpty) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (_context, _index) {
                return CustomUserListViewTile(
                  title: _users[_index].name,
                  subTitle: 'Last Seen: ${_users[_index].lastDayActive()}',
                  imageURL: _users[_index].imageURL,
                  height: _deviceHeight * 0.10,
                  isActive: _users[_index].wasRecentlyActive(),
                  isSelected:
                      _usersPageProvider.selectedUsers.contains(_users[_index]),
                  onTap: () {
                    print('On Tapped');
                    _usersPageProvider.updateSelectdUsers(_users[_index]);
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No Users Found.',
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
      }(),
    );
  }

  Widget _createChatBtn() {
    return Visibility(
      visible: _usersPageProvider.selectedUsers.isNotEmpty,
      child: RoundedButton(
        btnName: _usersPageProvider.selectedUsers.length == 1 ? 'Chat with ${_usersPageProvider.selectedUsers.first.name}' : 'Create Group Chat',
        height: _deviceHeight * 0.08,
        width: _deviceWidth * 0.80,
        onPressed: () {
          _usersPageProvider.createChat();
        },
      ),
    );
  }
}
