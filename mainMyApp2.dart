import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tema con Deslizamiento en AppBar',
      debugShowCheckedModeBanner: false,

      // Tema claro
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 255, 141, 141),
          onPrimary: Color.fromARGB(255, 0, 0, 0),
          background: Color.fromARGB(255, 255, 223, 223),
          onBackground: Color.fromARGB(255, 0, 0, 0),
        ),
        useMaterial3: true,
      ),

      // Tema oscuro
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 108, 2, 137),
          onPrimary: Color.fromARGB(255, 255, 255, 255),
          background: Color.fromARGB(255, 39, 2, 53),
          onBackground: Color.fromARGB(255, 255, 255, 255),
        ),
        useMaterial3: true,
      ),

      themeMode: _themeMode,

      home: MyHomePage(
        onSwipe: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final VoidCallback onSwipe;
  final bool isDarkMode;

  const MyHomePage({
    super.key,
    required this.onSwipe,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar dentro de GestureDetector
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            onSwipe(); // Cambia el tema al deslizar en el AppBar
          },
          child: AppBar(
            title: Text(isDarkMode ? "🌙 Tema Oscuro" : "☀️ Tema Claro"),
            backgroundColor: theme.primary,
            foregroundColor: theme.onPrimary,
            centerTitle: true,
          ),
        ),
      ),

      body: Container(
        color: theme.background,
        child: Center(
          child: Text(
            "Desliza sobre la barra superior para cambiar el tema 👆",
            style: TextStyle(fontSize: 18, color: theme.onBackground),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
