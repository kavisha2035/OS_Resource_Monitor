import 'package:courier_desktopapp/models/contact_model.dart';
import 'package:courier_desktopapp/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/consignment_model.dart';
import 'providers/consignment_provider.dart';
import 'views/auth_screen.dart';

Future<void> main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Register the adapter for your Consignment model
  Hive.registerAdapter(ConsignmentAdapter());
  Hive.registerAdapter(ContactAdapter());
  
  // Open the box. It will be created if it doesn't exist.
  await Hive.openBox<Consignment>('consignments');
  await Hive.openBox<Contact>('contacts');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the ConsignmentProvider to the entire widget tree
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConsignmentProvider()),
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: MaterialApp(
        title: 'Courier Desktop App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Anek Latin', // Assuming you've added this font
          scaffoldBackgroundColor: const Color(0xFFF3F7FA),
        ),
        home: AuthScreen(), // Start with the authentication screen
      ),
    );
  }
}
