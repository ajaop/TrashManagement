import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import '../AppServices/auth_service.dart';
import '../Models/user_details.dart';
import '../loader_animation.dart';
import 'signin.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String fullPhoneNum = '';
  AuthService authService = AuthService();
  String buttonText = 'Create Account',
      titleText = 'Sign Up',
      selectedGender = '';
  bool _obscureText = true, _loading = false, _userSigningUp = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getUserValues();
    return MaterialApp(
        scaffoldMessengerKey: _messangerKey,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xffA2D1AE),
          colorScheme:
              ThemeData().colorScheme.copyWith(primary: Color(0xff95C2A1)),
        ),
        home: Stack(
          children: [
            Scaffold(
              body: Center(
                child: SafeArea(
                    child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  titleText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                          color: Color(0xff1B3823),
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Firstname',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          fontSize: 16.0,
                                          color: Color(0xff1B3823)),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'John',
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Firstname is required';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Lastname',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          fontSize: 16.0,
                                          color: Color(0xff1B3823)),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Doe',
                                ),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (value) {},
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Lastname is required';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                          fontSize: 16.0,
                                          color: Color(0xff1B3823)),
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                enabled: _userSigningUp,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'test@gmail.com',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (value) {},
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'PhoneNumber',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 16.0,
                                            color: Color(0xff1B3823)),
                                  )),
                              const SizedBox(
                                height: 5.0,
                              ),
                              IntlPhoneField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                initialCountryCode: 'NG',
                                onChanged: (phone) {
                                  if (phone.number.startsWith('0')) {
                                    fullPhoneNum = phone.countryCode +
                                        phone.number.substring(1);
                                  } else {
                                    fullPhoneNum = phone.completeNumber;
                                  }
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Phone Number is Required';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 16.0,
                                            color: Color(0xff1B3823)),
                                  )),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                enabled: _userSigningUp,
                                controller: _passwordController,
                                obscureText: _obscureText,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.password),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(_obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off)),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    hintText: '*******'),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(100),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Password must be at least 6  character';
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 25.0,
                              ),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Gender',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                            fontSize: 16.0,
                                            color: Color(0xff1B3823)),
                                  )),
                              const SizedBox(
                                height: 5.0,
                              ),
                              DropDownTextField(
                                listSpace: 20,
                                listPadding: ListPadding(top: 20),
                                enableSearch: false,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Gender Required";
                                  } else {
                                    return null;
                                  }
                                },
                                textFieldDecoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0))),
                                dropDownList: const [
                                  DropDownValueModel(
                                      name: 'Male', value: "Male"),
                                  DropDownValueModel(
                                      name: 'Female', value: "Female"),
                                ],
                                listTextStyle:
                                    const TextStyle(color: Colors.black),
                                dropDownItemCount: 2,
                                onChanged: (val) {
                                  selectedGender = val.value;
                                },
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color(0xff19433C),
                                      minimumSize: const Size.fromHeight(55),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .button!
                                          .copyWith(
                                              fontSize: 20.0,
                                              color: Colors.white)),
                                  onPressed: !_loading
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _loading = true;
                                            });

                                            await authService.register(
                                                _firstNameController.text
                                                    .toString(),
                                                _lastNameController.text
                                                    .toString(),
                                                _emailController.text
                                                    .toString(),
                                                fullPhoneNum,
                                                _passwordController.text
                                                    .toString(),
                                                selectedGender,
                                                getImage(),
                                                context,
                                                _messangerKey);

                                            setState(() {
                                              _loading = false;
                                            });
                                          }
                                        }
                                      : null,
                                  child: Text(buttonText)),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Already have an account ?"),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          primary: Color(0xff19433C)),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    const SignIn())));
                                      },
                                      child: const Text('Sign in')),
                                ],
                              )
                            ],
                          )),
                    ),
                  ],
                )),
              ),
            ),
            if (_loading) const Center(child: Loader())
          ],
        ));
  }

  void getUserValues() {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final userDetails =
          ModalRoute.of(context)!.settings.arguments as UserDetails;

      _emailController.text = userDetails.email!;
      _passwordController.text = userDetails.password!;
      setState(() {
        _userSigningUp = false;
        titleText = 'Complete Sign Up';
        buttonText = 'Submit';
      });
    }
  }

  String getImage() {
    var rng = Random().nextInt(2) + 1;
    String imgUrl;
    if (selectedGender == 'Male') {
      imgUrl = 'images/man' + rng.toString() + '.png';
    } else {
      imgUrl = 'images/woman' + rng.toString() + '.png';
    }

    return imgUrl;
  }
}
