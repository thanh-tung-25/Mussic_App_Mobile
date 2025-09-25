import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/course/providers/weather_provider.dart';
import 'package:my_app/course/widget/Row2.dart';
import 'package:my_app/course/widget/Row.dart';
import 'package:my_app/course/widget/Temporature.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherProvider>().getWeatherCurrent();
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd-MM-yyyy');

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon thời tiết
            Image.asset(
              'assets/img/clear.png',
              height: 230,
              width: 230,
              fit: BoxFit.fill,
            ),

            const SizedBox(height: 10),

            // Nhiệt độ
            //const Temperature(),

            const SizedBox(height: 10),

            // Thành phố
            buildRow(),

            const SizedBox(height: 10),

            // Ngày tháng
            Text(
              df.format(DateTime.now()),
              style: const TextStyle(
                fontSize: 28,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Thông tin bổ sung
            buildRow2(),
          ],
        ),
      ),
    );
  }
}
