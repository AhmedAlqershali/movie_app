import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/common/extensions/size_extensions.dart';
import 'package:movieapp/payment/screens/add_new_card.dart';
import 'package:movieapp/utils/helpers.dart';

import '../../../common/constants/size_constants.dart';
import '../../../common/constants/translation_constants.dart';
import '../../../firebase_response.dart';
import '../../firebase/fb_auth_controller.dart';
import '../../themes/theme_color.dart';
import '../../widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  bool _obscureText = true;

  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  String _gender = 'M';

  @override
  void initState() {
    super.initState();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.vulcan,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.vulcan,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.dimen_32.w,
          vertical: Sizes.dimen_6.h,
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Text(
              'MOVIE'.toUpperCase(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            Text(
              'Create new account..',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              'Create account to start using app',
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontWeight: FontWeight.w300,
                height: 1,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameTextController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Full name',
                  prefixIcon: const Icon(Icons.person),
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
                await _performRegister();
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
            // const SizedBox(height: 10),
            // TextField(
            //   controller: _paymentTextController,
            //   keyboardType: TextInputType.emailAddress,
            //   decoration: InputDecoration(
            //       hintText: 'Full name',
            //       prefixIcon: const Icon(Icons.person),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide(
            //           color: Colors.blue.shade300,
            //           width: 0.8,
            //         ),
            //       )),
            // ),
            // const SizedBox(height: 10),
            SizedBox(height: 20),
            Button(
              onPressed: () async => await _performRegister(),
              text: TranslationConstants.register,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (checkData()) {
      await _register();
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

  Future<void> _register() async {
    FirebaseResponse firebaseResponse = await FbAuthController().createAccount(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    showSnackBar(
      context,
      message: firebaseResponse.message,
      error: !firebaseResponse.success,
    );
    if(firebaseResponse.success)
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewCardScreen()),);
  }
}
