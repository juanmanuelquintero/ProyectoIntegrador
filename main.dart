import 'package:flutter/material.dart';

void main() => runApp(const InmortalKingApp());

class InmortalKingApp extends StatelessWidget {
  const InmortalKingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inmortal King',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B61FF),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF1C1B29),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2A2940),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: const Color(0xFF26253B),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF7B61FF)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Menú Principal',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            _drawerItem(Icons.home_outlined, 'Inicio'),
            _drawerItem(Icons.person_outline, 'Perfil'),
            _drawerItem(Icons.settings_outlined, 'Ajustes'),
            const Divider(color: Colors.white24),
            _drawerItem(Icons.logout, 'Cerrar sesión', isLogout: true),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: const Text('Inmortal King'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            tooltip: 'Notificaciones',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sin nuevas notificaciones'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next_rounded),
            tooltip: 'Siguiente',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NextPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Nuevo logo circular con gradiente
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFFB57BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(
                Icons.shield_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Bienvenido a Inmortal King',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Tu portal hacia la gestión definitiva. Explora, personaliza y domina cada opción del menú.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
            ),
            const SizedBox(height: 28),
            Card(
              color: const Color(0xFF2C2B44),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFF7B61FF),
                      size: 28,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Navega por Inicio, Perfil, Ajustes y mucho más desde el menú lateral.',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.flash_on_rounded),
                  label: const Text('Iniciar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B61FF),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Entrando al sistema...'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.info_outline_rounded),
                  label: const Text('Detalles'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF7B61FF)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Inmortal King',
                      applicationVersion: '2.0.0',
                      children: const [
                        Text('Un rediseño completo con Flutter y Material 3.'),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 36),
            Text(
              '© ${DateTime.now().year} Inmortal King • Todos los derechos reservados',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white38),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  ListTile _drawerItem(IconData icon, String text, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isLogout ? 'Sesión cerrada' : '$text seleccionado'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Siguiente Página')),
      body: const Center(
        child: Text(
          'Bienvenido al nuevo diseño 🔮',
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
      ),
    );
  }
}
