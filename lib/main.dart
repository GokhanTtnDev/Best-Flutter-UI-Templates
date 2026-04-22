import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/constants/app_colors.dart';
import 'templates/01_fintech_terminal/fintech_dashboard.dart';
import 'templates/02_hotel_pms/hotel_pms_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const CrystalFinanceApp());
}

class CrystalFinanceApp extends StatelessWidget {
  const CrystalFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Portfolio Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      home: const AppShowcaseScreen(),
    );
  }
}

class AppShowcaseScreen extends StatefulWidget {
  const AppShowcaseScreen({super.key});

  @override
  State<AppShowcaseScreen> createState() => _AppShowcaseScreenState();
}

class _AppShowcaseScreenState extends State<AppShowcaseScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _mockups = [
    {
      'label': 'Premium Fintech App',
      'image': 'assets/fintechmockup.png',
      'description': 'Advanced Trading & Wallet Dashboard',
    },
    {
      'label': 'Next-Gen Hotel PMS',
      'image': 'assets/hotelsmockup.png',
      'description': 'Dynamic Calendar & Operations',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int index) {
    if (index < 0 || index >= _mockups.length) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutQuart,
    );
  }

  void _openApp(BuildContext context, int index) {
    Widget destination;

    if (index == 0) {
      destination = const FintechDashboard();
    } else {
      destination = const HotelPmsDashboard();
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.05);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: animation.drive(tween),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E293B),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: _mockups.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildAnimatedMockup(context, index);
            },
          ),
          _buildNavigationOverlay(),
        ],
      ),
    );
  }

  Widget _buildAnimatedMockup(BuildContext context, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 1.0;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page! - index;
          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
        } else if (index != 0) {
          value = 0.7;
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: (value * value).clamp(0.0, 1.0),
                  child: GestureDetector(
                    onTap: () => _openApp(context, index),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        // Genişlik ve yüksekliği mockup'ı tam gösterecek şekilde serbest bıraktık
                        width: 340,
                        height: 650,
                        color: Colors.transparent, // Sadece şeffaf bir kapsayıcı
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mockup resminin kendisi (Saydam PNG, BoxFit.contain ile kesilmez)
                            Image.asset(
                              _mockups[index]['image']!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              height: double.infinity,
                            ),

                            // "Tap to Explore" butonu (Mockup'ın üzerine binen şık bir hap buton)
                            Positioned(
                              bottom: 40,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.65), // Saydam siyah arka plan
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                  ),
                                ),
                                child: const Text(
                                  'Tap to Explore',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Column(
                  children: [
                    Text(
                      _mockups[index]['label']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _mockups[index]['description']!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationOverlay() {
    return Positioned.fill(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _mockups.length,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 32 : 12,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.blueAccent
                          : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () => _navigateToPage(_currentPage - 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: _currentPage > 0
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      size: 28,
                    ),
                  ),
                  IconButton(
                    onPressed: _currentPage < _mockups.length - 1
                        ? () => _navigateToPage(_currentPage + 1)
                        : null,
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _currentPage < _mockups.length - 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.1),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}