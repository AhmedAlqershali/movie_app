import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/firebase_response.dart';
import 'package:movieapp/presentation/screens/home/home_screen.dart';
import 'package:movieapp/utils/helpers.dart';
import '../../../common/constants/size_constants.dart';
import '../../../common/constants/translation_constants.dart';
import '../../blocs/login/login_cubit.dart';
import '../../firebase/fb_auth_controller.dart';
import '../../themes/theme_color.dart';
import '../../widgets/button.dart';
import 'forget_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  bool _obscureText = true;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.vulcan,
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_32.w,
          vertical: Sizes.dimen_24.h,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Text(
              'MOVIE'.toUpperCase(),
                style: Theme.of(context).textTheme.headline3,
                textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Text(
              'Login to Movie App',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blue.shade300,
                      width: 0.8,
                    ),
                  )),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordTextController,
              keyboardType: TextInputType.text,
              obscureText: _obscureText,
              textInputAction: TextInputAction.go,
              onSubmitted: (String value) async {
                await _performLogin();
              },
              decoration: InputDecoration(
                hintText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade300,
                    width: 0.8,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () =>
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgetPasswordScreen()),),
                child: Text(
                  'Forget Password?',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Button(
              onPressed: () async => await _performLogin(),
              text: TranslationConstants.signIn,
            ),

            Button(
              onPressed: () =>
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeScreen()),),
              text: TranslationConstants.guestSignIn,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()),),
                  child: Text(
                    'Create Now!',
                    style: GoogleFonts.nunito(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (checkData()) {
      await _login();
    }
  }

  bool checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data!', error: true);
    return false;
  }

  Future<void> _login() async {
    FirebaseResponse firebaseResponse = await FbAuthController().signIn(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    showSnackBar(
      context,
      message: firebaseResponse.message,
      error: !firebaseResponse.success,
    );
    // if(firebaseResponse.success)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  HomeScreen()),);

  }
}
