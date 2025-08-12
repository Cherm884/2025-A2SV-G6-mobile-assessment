import 'package:chatting_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:chatting_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:chatting_app/features/auth/presentation/pages/signin_page.dart';
import 'package:chatting_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:chatting_app/features/chat/presentation/bloc/chat_bloc_bloc.dart';
import 'package:chatting_app/features/chat/presentation/page/home.dart';
import 'package:chatting_app/injection_container.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<AuthBloc>(),),
        BlocProvider(create: (context) => di.sl<ChatBloc>(),)
      
      ],
      
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),

        routes: {
          '/signup': (context) => const SignUpPage(),
          '/login': (context) => const SigninPage(),
          '/home': (context) => const Home()
        },
      ),
    );
  }
}
