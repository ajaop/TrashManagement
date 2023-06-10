import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trash_management/AuthenticationFeature/signup.dart';

import '../AppServices/auth_service.dart';
import '../loader_animation.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthService authService = AuthService();
  bool _obscureText = true, _loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              'Welcome Back',
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
                              'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .copyWith(
                                      fontSize: 16.0, color: Color(0xff1B3823)),
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
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
                            height: 70.0,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xff19433C),
                                  minimumSize: const Size.fromHeight(55),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .button!
                                      .copyWith(
                                          fontSize: 20.0, color: Colors.white)),
                              onPressed: !_loading
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _loading = true;
                                        });

                                        await authService.login(
                                            _emailController.text.toString(),
                                            _passwordController.text.toString(),
                                            context,
                                            _messangerKey);

                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    }
                                  : null,
                              child: Text('Sign in')),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Dont have an account ?'),
                              TextButton(
                                  style: TextButton.styleFrom(
                                      primary: Color(0xff19433C)),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const SignUp())));
                                  },
                                  child: const Text('Sign up')),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
            ),
          ),
          if (_loading) const Center(child: Loader())
        ],
      ),
    );
  }
}
