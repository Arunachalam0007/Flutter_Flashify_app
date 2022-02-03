// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

// Widgets
import '../widgets/custom_input_field.dart';
import '../widgets/rounded_button.dart';

// Providers
import '../providers/authentication_provider.dart';

// Services
import '../services/navigation_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navService;

  String? _loginEmail;
  String? _loginPassword;

  final _loginFormKey = GlobalKey<FormState>();

  final _emailRegex = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
  final _passwordRegex = r".{8,}";

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);
    _navService =  GetIt.instance.get<NavigationService>();
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(

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
            _loginTitle(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginForm(),
            SizedBox(
              height: _deviceHeight * 0.04,
            ),
            _loginBtn(),
            SizedBox(
              height: _deviceHeight * 0.02,
            ),
            _registerAccountLink(),
          ],
        ),
      ),
    );
  }

  Widget _loginTitle() {
    return Container(
      height: _deviceWidth * 0.15,
      child: const Text(
        '⚡Flashify⚡',
        style: TextStyle(
          fontSize: 40,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Container(
        height: _deviceHeight * 0.18,
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextFormField(
                obscureText: false,
                hintText: 'Email',
                regEx: _emailRegex,
                onSaved: (_val) {
                  setState(() {
                    _loginEmail = _val;
                  });
                },
              ),
              CustomTextFormField(
                obscureText: true,
                hintText: 'Password',
                regEx: _passwordRegex,
                onSaved: (_val) {
                  _loginPassword = _val;
                },
              ),
            ],
          ),
        ));
  }

  Widget _loginBtn() {
    return RoundedButton(
      btnName: 'Login',
      height: _deviceHeight * 0.065,
      width: _deviceWidth * 0.65,
      onPressed: () {
        if(_loginFormKey.currentState!.validate()){
          // this will call onSaved call back in Form Children
          _loginFormKey.currentState?.save();
          print('EMail: ${_loginEmail} Password: $_loginPassword');
          _auth.loginUsingEmailAndPassword(_loginEmail!, _loginPassword!);
        }
      },
    );
  }

  Widget _registerAccountLink() {
    return GestureDetector(
      onTap: () {
        print('Don\'t Have an Account?');
        _navService.navigateToRoute('/register');
      },
      child: Container(
        child: const Text(
          'Don\'t have an account?',
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}
