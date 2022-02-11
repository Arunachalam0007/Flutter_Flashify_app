// Packages
import 'package:flashify_app/widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Services
import '../services/media_service.dart';
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/navigation_service.dart';

//Widgets

import '../widgets/custom_input_field.dart';
import '../widgets/rounded_button.dart';

//Provider

import '../providers/authentication_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late AuthenticationProvider _auth;
  late CloudStorageService _storageService;
  late DatabaseService _databaseService;
  late NavigationService _navigationService;

  PlatformFile? _profileImage;
  final _regFormKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String? _pass;

  final _emailRegex =
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  final _passwordRegex = r".{8,}";

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _storageService = GetIt.instance.get<CloudStorageService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _deviceWidth * 0.03,
          vertical: _deviceHeight * 0.02,
        ),
        height: _deviceHeight * 0.98,
        width: _deviceWidth * 0.97,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            _profileImageField(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _regFormInput(),
            SizedBox(
              height: _deviceHeight * 0.05,
            ),
            _regBtn(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageField() {
    return GestureDetector(
      onTap: () {
        GetIt.instance.get<MediaService>().pickImageFromLibrary().then((_file) {
          setState(() {
            _profileImage = _file;
          });
        });
      },
      child: () {
        if (_profileImage != null) {
          return RoundedImageFile(
            key: UniqueKey(),
            image: _profileImage!,
            size: _deviceHeight * 0.15,
          );
        } else {
          return RoundedImageNetwork(
            key: UniqueKey(),
            imagePath:
                'https://firebasestorage.googleapis.com/v0/b/flashify-chat-flutter-app.appspot.com/o/images%2Fusers%2FlZ1RnmsSjcd0InPzlGw6WVCro6z1%2FArunsha%20pic.png?alt=media&token=5f7ebf05-5a20-4393-be96-b9552d1854e3',
            size: _deviceHeight * 0.15,
          );
        }
      }(),
    );
  }

  Widget _regFormInput() {
    return Container(
      height: _deviceHeight * 0.35,
      child: Form(
        key: _regFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomTextFormField(
              onSaved: (_val) {
                setState(() {
                  _name = _val;
                });
              },
              regEx: r'.{3,}',
              hintText: 'Name',
              icon: Icons.drive_file_rename_outline,
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_val) {
                setState(() {
                  _email = _val;
                });
              },
              regEx: _emailRegex,
              hintText: 'Email',
              icon: Icons.email,
              obscureText: false,
            ),
            CustomTextFormField(
              onSaved: (_val) {
                setState(() {
                  _pass = _val;
                });
              },
              regEx: _passwordRegex,
              hintText: 'Password',
              icon: Icons.lock_outline_sharp,
              obscureText: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _regBtn() {
    return RoundedButton(
        height: _deviceHeight * 0.065,
        width: _deviceWidth * 0.65,
        btnName: 'Register',
        onPressed: () async {
          if (_regFormKey.currentState!.validate()) {

            _regFormKey.currentState!.save();
            String? _uid = await _auth.registerUserUsingEmailPassword(
              _email!,
              _pass!
            );
            String? _imageURL = await _storageService.saveUserImageToStorage(
              _uid!,
              _profileImage!
            );
            print('Image URL Val: $_imageURL');
            await _databaseService.createUserData(
              _uid,
              _email!,
              _name!,
              _imageURL ?? ""
            );
            _navigationService.goBack();
          } else {
            print('Choose Image or Enter All the fileds');
          }
        });
  }
}
