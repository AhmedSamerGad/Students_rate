import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/app_route.dart';
import 'package:news_app/firebase_options.dart';
import 'package:news_app/logic/calendar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/logic/otp_cubit.dart';
import 'package:news_app/logic/users_cubit.dart';

import 'constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  final calendarCubit = CalendarCubit();
  await calendarCubit.initialize();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final String starter;
  if (firebaseAuth.currentUser == null) {
    starter = loginScreen;
  } else {
    starter = navigationScreen;
  }
  runApp(MyApp(
    appRouter: AppRouter(),
    calendarCubit: calendarCubit,
    star: starter,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key,
      required this.appRouter,
      required this.calendarCubit,
      required this.star});

  final AppRouter appRouter;
  final CalendarCubit calendarCubit;
  final String star;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: calendarCubit,
        ),
        BlocProvider(
          create: (context) => OtpCubit(),
        ),
        BlocProvider(
          create: (context) => UsersCubit()..initlizer(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          // Define the color scheme for your app
          colorScheme: const ColorScheme(
            primary: Color(0xFF4CAF50), // Primary color (Green)
            secondary: Color(0xFF8BC34A), // Secondary color (Lighter Green)
            surface: Color(0xFFFAF9F6), // Surface color (Off-White)
            background: Color(0xFFE8F5E9), // Background color (Light Green)
            error: Color(0xFFB00020), // Error color
            onPrimary:
                Colors.white, // Color used for text/icons on primary color
            onSecondary:
                Colors.white, // Color used for text/icons on secondary color
            onSurface:
                Color(0xFF424242), // Color used for text/icons on surface color
            onBackground: Color(
                0xFF424242), // Color used for text/icons on background color
            onError: Colors.white, // Color used for text/icons on error color
            brightness: Brightness.light, // Theme brightness
          ),

          // AppBar theme
          appBarTheme: AppBarTheme(
            color: const Color(0xFF4CAF50), // Primary color (Green)
            iconTheme: const IconThemeData(color: Colors.white), // White icons
            titleTextStyle: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // White text
          ),

          // Button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF8BC34A), // Button color (Lighter Green)
              foregroundColor: Colors.white, // Text color (White)
              textStyle: const TextStyle(fontSize: 16), // Text style for button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
            ),
          ),

          // Floating Action Button theme
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF8BC34A), // Button color (Lighter Green)
            foregroundColor: Colors.white, // Icon color (White)
          ),

          // Bottom Navigation Bar theme
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor:
                Color(0xFFE8F5E9), // Background color (Light Green)
            selectedItemColor: Color(0xFF4CAF50), // Selected item color (Green)
            unselectedItemColor:
                Color(0xFF9E9E9E), // Unselected item color (Gray)
          ),

          // Text theme
          textTheme: const TextTheme(
            bodyText1: TextStyle(
              color: Color(0xFF424242), // Dark Gray for body text
              fontSize: 14,
            ),
            bodyText2: TextStyle(
              color: Color(0xFF424242), // Dark Gray for secondary body text
              fontSize: 12,
            ),
            headline1: TextStyle(
              color: Color(0xFF424242), // Dark Gray for large headlines
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: Color(0xFF424242), // Dark Gray for AppBar title
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            caption: TextStyle(
              color: Color(0xFF9E9E9E), // Gray for captions
              fontSize: 12,
            ),
          ),

          // Input Decoration theme
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: const Color(0xFFF5F5F5), // Light Gray for input fields
          ),

          // Card theme
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
          ),

          // Icon theme
          iconTheme: const IconThemeData(
            color: Color(0xFF424242), // Dark Gray for icons
          ),
        ),
        initialRoute: star,
        onGenerateRoute: appRouter.generateRoute,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: const Locale('ar'),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
