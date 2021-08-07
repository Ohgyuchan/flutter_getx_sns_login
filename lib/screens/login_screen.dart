import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_getx_sns_login/screens/profile_screen.dart';
import 'package:flutter_getx_sns_login/src/authentication.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final _loginTap = 0;
  final _isLoging = false;
  final _loginFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final ButtonController buttonController = Get.put(ButtonController());

  final List<Tab> _loginTabs = <Tab>[
    Tab(text: '로그인'),
    Tab(text: '회원가입'),
  ];

  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signUpEmailController = TextEditingController();
  final TextEditingController _signUpPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _loginTap,
      child: Scaffold(
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: _bodyWidget(context)),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: Get.height,
        width: Get.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Theme(
                data: ThemeData().copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.black,
                  labelStyle:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                  unselectedLabelColor: Colors.grey,
                  unselectedLabelStyle:
                      TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
                  tabs: _loginTabs,
                ),
              ),
            ),
            Container(
              height: 500,
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _loginTabBarView(),
                  _signUpTabBarView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signUpTabBarView() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 45.0),
          _emailSignUpFiled(),
          SizedBox(
            height: 15.0,
          ),
          Obx(() => _signUpButton()),
        ],
      ),
    );
  }

  Widget _loginTabBarView() {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 45.0),
          _emailLoginFiled(),
          SizedBox(
            height: 15.0,
          ),
          FutureBuilder(
            future: Authentication.initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error initializing Firebase');
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (_isLoging) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      _loginButton(),
                      _googleLoginButton(),
                      _facebookLoginButton(),
                    ],
                  );
                }
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget _signUpButton() => MaterialButton(
        color: buttonController.active.value ? Color(0xFF5C4FE1) : Colors.grey,
        shape: StadiumBorder(),
        onPressed: () {
          if (_signUpFormKey.currentState!.validate()) {
            print(_signUpEmailController.text.toString());
            print(_signUpPasswordController.text.toString());
          }
        },
        elevation: 5.0,
        child: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    '회원가입 완료하기',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      );

  Widget _loginButton() => MaterialButton(
        color: buttonController.active.value ? Color(0xFF5C4FE1) : Colors.grey,
        shape: StadiumBorder(),
        onPressed: () {
          if (_loginFormKey.currentState!.validate()) {
            print(_loginEmailController.text.toString());
            print(_loginPasswordController.text.toString());
          }
        },
        elevation: 5.0,
        child: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  '로그인',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _googleLoginButton() => MaterialButton(
        color: Colors.black,
        shape: StadiumBorder(),
        onPressed: () {
          _googleSignIn();
        },
        elevation: 5.0,
        child: Container(
          width: 200,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Image.asset(
                  'packages/sign_button/images/google.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  '구글 로그인',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _facebookLoginButton() => MaterialButton(
        color: Colors.black,
        shape: StadiumBorder(),
        onPressed: () {},
        elevation: 5.0,
        child: Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Image.asset(
                  'packages/sign_button/images/facebook.png',
                  width: 25.0,
                  height: 25.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  '페이스북 로그인',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Form _emailLoginFiled() {
    return Form(
      key: _loginFormKey,
      onChanged: () {
        if (_loginEmailController.text.isNotEmpty &&
            _loginPasswordController.text.isNotEmpty) {
          if (_loginFormKey.currentState!.validate())
            buttonController.activation();
        } else {
          buttonController.inactivation();
        }
      },
      child: Column(
        children: [
          emailField(_loginEmailController),
          SizedBox(height: 25.0),
          passwordField(_loginPasswordController),
        ],
      ),
    );
  }

  Form _emailSignUpFiled() {
    return Form(
      key: _signUpFormKey,
      onChanged: () {
        if (_signUpEmailController.text.isNotEmpty &&
            _signUpPasswordController.text.isNotEmpty) {
          if (_signUpFormKey.currentState!.validate())
            buttonController.activation();
        } else {
          buttonController.inactivation();
        }
      },
      child: Column(
        children: [
          emailField(_signUpEmailController),
          SizedBox(height: 25.0),
          passwordField(_signUpPasswordController),
        ],
      ),
    );
  }

  Widget emailField(TextEditingController _emailController) => TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          prefixIcon: Icon(Icons.alternate_email),
          hintText: "이메일",
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return '이메일을 입력하세요.';
          } else if (!value.isEmail) {
            return '이메일 형식이 아닙니다.';
          } else {
            return null;
          }
        },
      );

  Widget passwordField(TextEditingController _passwordController) =>
      TextFormField(
        obscureText: true,
        controller: _passwordController,
        style: TextStyle(
          fontSize: 20.0,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          prefixIcon: Icon(Icons.vpn_key_outlined),
          hintText: "비밀번호",
          border: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        validator: (value) {
          if (value!.trim().isEmpty) {
            return '비밀번호를 입력하세요.';
          } else {
            return null;
          }
        },
      );

  Future<void> _googleSignIn() async {
    User? user = await Authentication.signInWithGoogle();

    if (user != null) {
      Get.off(
        () => ProfileScreen(),
      );
    }
  }

  Future<void> _facebookSignIn() async {
    try {
      User? user = await Authentication.signInWithFacebook();

      if (user != null) {
        Get.off(
          () => ProfileScreen(),
        );
      }
    } catch (e) {}
  }
}

class ButtonController extends GetxController {
  RxBool active = false.obs;

  void activation() {
    active.value = true;
    print('activation = ${active.value}');
  }

  void inactivation() {
    active.value = false;
    print('inactivation = ${active.value}');
  }
}
