import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const AgeCalculatorApp());
}

class AgeCalculatorApp extends StatelessWidget {
  const AgeCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Age Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/age_animation.json', width: 200, height: 200),
            const SizedBox(height: 20),
            const Text(
              'Age Calculator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _dateController = TextEditingController();
  String? _calculatedAge;
  String? _zodiacSign;
  String? _funFact;

  final Map<String, String> zodiacSigns = {
    "Capricorn": "December 22 - January 19",
    "Aquarius": "January 20 - February 18",
    "Pisces": "February 19 - March 20",
    "Aries": "March 21 - April 19",
    "Taurus": "April 20 - May 20",
    "Gemini": "May 21 - June 20",
    "Cancer": "June 21 - July 22",
    "Leo": "July 23 - August 22",
    "Virgo": "August 23 - September 22",
    "Libra": "September 23 - October 22",
    "Scorpio": "October 23 - November 21",
    "Sagittarius": "November 22 - December 21",
  };

  final Map<String, String> funFacts = {
    "Capricorn":
        "Capricorns are known for their discipline and responsibility!",
    "Aquarius": "Aquarius is the most humanitarian zodiac sign.",
    "Pisces": "Pisces are incredibly intuitive and compassionate.",
    "Aries": "Aries are natural-born leaders with boundless energy!",
    "Taurus": "Taurus loves stability and is incredibly reliable.",
    "Gemini": "Geminis are adaptable and curious about everything.",
    "Cancer": "Cancers are deeply intuitive and emotional.",
    "Leo": "Leos thrive in the spotlight and love attention!",
    "Virgo": "Virgos are perfectionists who pay attention to details.",
    "Libra": "Libras value balance, harmony, and partnerships.",
    "Scorpio": "Scorpios are passionate and loyal to the core.",
    "Sagittarius": "Sagittarius loves adventure and exploring new things.",
  };

  void _calculateAgeAndDetails() {
    if (_dateController.text.isEmpty) {
      setState(() {
        _calculatedAge = "Please enter a valid date!";
        _zodiacSign = null;
        _funFact = null;
      });
      return;
    }

    try {
      final dob = DateFormat('yyyy-MM-dd').parse(_dateController.text);
      final today = DateTime.now();

      if (dob.isAfter(today)) {
        setState(() {
          _calculatedAge = "Date of birth cannot be in the future!";
          _zodiacSign = null;
          _funFact = null;
        });
        return;
      }

      int years = today.year - dob.year;
      int months = today.month - dob.month;
      int days = today.day - dob.day;

      if (days < 0) {
        months -= 1;
        final prevMonth = DateTime(today.year, today.month - 1, 0);
        days += prevMonth.day;
      }
      if (months < 0) {
        years -= 1;
        months += 12;
      }

      final zodiac = _determineZodiacSign(dob);
      setState(() {
        _calculatedAge = "$years years, $months months, $days days";
        _zodiacSign = zodiac;
        _funFact = funFacts[zodiac];
      });
    } catch (e) {
      setState(() {
        _calculatedAge = "Invalid date format! Use YYYY-MM-DD.";
        _zodiacSign = null;
        _funFact = null;
      });
    }
  }

  String _determineZodiacSign(DateTime dob) {
    final month = dob.month;
    final day = dob.day;

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18))
      return "Aquarius";
    if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) return "Pisces";
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return "Aries";
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return "Taurus";
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return "Gemini";
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return "Cancer";
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return "Leo";
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return "Virgo";
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return "Libra";
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21))
      return "Scorpio";
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21))
      return "Sagittarius";
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19))
      return "Capricorn";

    return "Unknown";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Zodiac & Age Calculator'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Enter your Date of Birth',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  labelText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateAgeAndDetails,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.purple,
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              if (_calculatedAge != null)
                Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          "Age: $_calculatedAge",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Zodiac Sign: $_zodiacSign",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Fun Fact: $_funFact",
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
