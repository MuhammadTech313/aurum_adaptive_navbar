import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/theme.dart';
import 'features/navigation/state/navbar_state.dart';
import 'features/home/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait on mobile; unrestricted on web/desktop
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const AurumApp());
}

class AurumApp extends StatelessWidget {
  const AurumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NavbarState(),
      child: MaterialApp(
        title: 'AURUM — Luxury Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AurumTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}