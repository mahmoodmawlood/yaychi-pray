import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'location.dart';
import 'location_page.dart';
import 'restart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocationAdapter());
  //await Hive.deleteBoxFromDisk('locations');
  var box = await Hive.openBox<Location>('locations');  // already there
 

if(box.isEmpty){
  await box.addAll([
    Location('أربيل', 36.188, 44.01, 3.0),
    Location('كركوك', 35.467, 44.392, 3.0),
    Location('بغداد', 33.315, 44.366, 3.0),
    Location('المدينة', 24.467, 39.6, 3.0),
    Location('مكة', 24.467, 39.6, 3.0),
    Location('سليمانية', 35.556, 45.435, 3.0),
    Location('Ankara', 39.92, 32.854, 3.0),
    Location('Istanbul', 41.008, 28.978, 3.0),
    Location('موصل', 36.349, 43.158, 3.0),
  ]); 
   }

  //runApp(MyApp());
  runApp(RestartWidget(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Saver',
      locale: const Locale('en'), 
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ],
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: const LocationPage(),
        ),
    );
  }
}