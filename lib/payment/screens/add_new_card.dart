import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movieapp/presentation/screens/auth/login_screen.dart';

import '../../common/constants/translation_constants.dart';
import '../../presentation/widgets/button.dart';
import '../components/card_type.dart';
import '../components/card_utilis.dart';
import '../components/input_formatters.dart';
import '../constains.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({Key? key}) : super(key: key);

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  TextEditingController cardNumberController = TextEditingController();

  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum(){
  if(cardNumberController.text.length <= 6){
    String cardNum = CardUtils.getCleanedNumber(cardNumberController.text) ;
    CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
    if(type != cardType){
      setState(() {
        cardType = type;
      });
    }
  }
  }
  @override
  void initState() {
    cardNumberController.addListener(() {
      getCardTypeFrmNum();
    },);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141221),
      appBar: AppBar(
        excludeHeaderSemantics: false,
        title: Padding(
          padding:  EdgeInsets.only(left: 30),
          child: Text("Credit Card",style: TextStyle(color: Colors.white,fontSize: 26),),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            children: [
              SizedBox(height: 16,),
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        filled: true, //<-- SEE HERE
                        fillColor: Color(0xFFE8E8E8),
                        hintText: "Card number",
                        suffixIcon:
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardUtils.getCardIcon(cardType),
                        ),
                        prefixIcon:cardType == CardType.Invalid ? null : Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset("assets/card/credit.png"),
                        ),
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54, width: 1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white54, width: 1),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            filled: true, //<-- SEE HERE
                            fillColor: Color(0xFFE8E8E8),
                            hintText: "Full name",
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset("assets/card/user.png"),
                            )),
                      ),
                    ),
                    Row(
                      children: [

                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54, width: 1),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54, width: 1),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                filled: true, //<-- SEE HERE
                                fillColor: Color(0xFFE8E8E8),
                                hintText: "CVV",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/card/cvv.png"),
                                )),

                          ),
                        ),
                        SizedBox(width: defaultPadding,),

                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.black),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                              CardMonthInputFormatter(),
                            ],
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54, width: 1),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white54, width: 1),
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                filled: true, //<-- SEE HERE
                                fillColor: Color(0xFFE8E8E8),
                                hintText: "MM/YY",
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset("assets/card/calendar.png"),
                                )),

                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.only(top: defaultPadding,bottom: defaultPadding),
                child: Button(
                  text: TranslationConstants.subscription,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
                    // Navigator.pop(context);

                  },),
              )
            ],),
        ),
      ),
    );
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      return newValue;
    }
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();
    for(var i = 0; i <inputData.length; i++){
      buffer.write(inputData[i]);
      int index = i + 1;
      if(index % 4 == 0 && inputData.length != index){
        buffer.write("  "); // double space
      }
    }
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.toString().length,),
    );
  }
  
}