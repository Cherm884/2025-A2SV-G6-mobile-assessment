import 'package:chatting_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatting_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:chatting_app/features/auth/presentation/widget/form_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  static const storageKey = 'ACCESS_TOKEN';
  late final FlutterSecureStorage storage;

  @override
  void initState() {
    super.initState();
    storage = const FlutterSecureStorage();
    _checkToken();
  }

  void _checkToken() async {
    final result = await storage.read(key: storageKey);
    if (mounted && result != null && result.isNotEmpty) {
      context.read<AuthBloc>().add(GetMeEvent());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // adjust for keyboard
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 122),
                  child: SizedBox(
                    height: 50,
                    width: 144,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        side: const BorderSide(
                          color: Color.fromRGBO(63, 81, 243, 1),
                          width: 0.93,
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'ECOM',
                        style: GoogleFonts.caveatBrush(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          color: const Color.fromRGBO(63, 81, 243, 1),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sign into your account',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  debugPrint('AuthBloc State: $state');
                  if (state is Authenticated) {
                    Navigator.pushNamed(context, '/home');
                  } else if (state is UnAuthenticated) {
                    Navigator.pushReplacementNamed(context, '/login');
                  }
                },
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ErrorState) {
                    return Center(child: Text(state.message));
                  }

                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        FormStyle(
                          label: 'Email',
                          hint: 'ex: jon.smith@email.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        FormStyle(
                          label: 'Password',
                          hint: '*********',
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Min 6 characters required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  // Dispatch login event
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51F3),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'SIGN IN',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF888888),
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text(
                      'SIGN UP',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF3F51F3),
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
