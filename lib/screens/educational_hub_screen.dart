import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EducationalHubScreen extends StatefulWidget {
  static const routeName = '/learn';
  const EducationalHubScreen({super.key});

  @override
  State<EducationalHubScreen> createState() => _EducationalHubScreenState();
}

class TipSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> tips;

  TipSearchDelegate({required this.tips});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? tips.take(5).toList()
        : tips.where((tip) =>
            tip['title'].toString().toLowerCase().contains(query.toLowerCase()) ||
            tip['summary'].toString().toLowerCase().contains(query.toLowerCase()) ||
            tip['category'].toString().toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final tip = suggestionList[index];
        return ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                tip['icon'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          title: Text(
            tip['title'],
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            tip['category'],
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          onTap: () {
            close(context, tip['title']);
          },
        );
      },
    );
  }
}

class _EducationalHubScreenState extends State<EducationalHubScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> categories = [
    '💧 Water Saving',
    '⚡ Energy',
    '♻️ Recycling',
    '🚌 Sustainable Transport',
    '🌱 Gardening',
    '🛍️ Shopping',
    '🏠 Home',
    '🍽️ Food',
  ];

  final List<Map<String, dynamic>> tips = [
    {
      'title': 'Switch to LED Bulbs',
      'icon': '💡',
      'summary': 'Replace traditional bulbs with LED alternatives to save energy and reduce costs.',
      'category': '⚡ Energy',
      'isRead': false,
    },
    {
      'title': 'Fix Leaky Faucets',
      'icon': '🚰',
      'summary': 'A dripping faucet can waste thousands of liters annually. Check and repair leaks promptly.',
      'category': '💧 Water Saving',
      'isRead': false,
    },
    {
      'title': 'Smart Power Strips',
      'icon': '🔌',
      'summary': 'Use smart power strips to eliminate phantom energy consumption from standby devices.',
      'category': '⚡ Energy',
      'isRead': false,
    },
    {
      'title': 'Proper Waste Sorting',
      'icon': '🗑️',
      'summary': 'Learn which items go in recycling, compost, and landfill bins.',
      'category': '♻️ Recycling',
      'isRead': false,
    },
    {
      'title': 'Try Bike Commuting',
      'icon': '🚲',
      'summary': 'Consider cycling for short trips to reduce emissions and improve health.',
      'category': '🚌 Sustainable Transport',
      'isRead': false,
    },
    {
      'title': 'Composting Basics',
      'icon': '🌱',
      'summary': 'Start composting kitchen scraps to create nutrient-rich soil for your garden.',
      'category': '🌱 Gardening',
      'isRead': false,
    },
    {
      'title': 'Eco-friendly Shopping',
      'icon': '🛍️',
      'summary': 'Bring reusable bags and choose products with minimal packaging.',
      'category': '🛍️ Shopping',
      'isRead': false,
    },
    {
      'title': 'Energy-Efficient Windows',
      'icon': '🪟',
      'summary': 'Install double-pane windows to improve insulation and reduce energy costs.',
      'category': '🏠 Home',
      'isRead': false,
    },
  ];

  String selectedCategory = 'All';
  int readTipsCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> getFilteredTips() {
    if (selectedCategory == 'All') return tips;
    return tips.where((tip) => tip['category'] == selectedCategory).toList();
  }

  void toggleTipRead(int index) {
    try {
      setState(() {
        final tip = getFilteredTips()[index];
        tip['isRead'] = !tip['isRead'];
        readTipsCount = tips.where((tip) => tip['isRead']).length;
      });
    } catch (e) {
      debugPrint('Error toggling tip read status: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update tip status'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 20,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learn & Grow',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'Quick tips to reduce your footprint',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.black87),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: TipSearchDelegate(tips: tips),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Tracker
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Progress',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$readTipsCount of ${tips.length} tips',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(
                    begin: 0,
                    end: readTipsCount / tips.length,
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  builder: (context, value, _) => Stack(
                    children: [
                      LinearProgressIndicator(
                        value: value,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                        minHeight: 8,
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            '${(value * 100).toInt()}%',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Scroll Indicator
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left, color: Colors.grey[400]),
                Text(
                  'Scroll for more categories',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),

          // Category Filter Bar
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
                scrollbars: true,
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ...['All', ...categories].map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(
                          category,
                          style: GoogleFonts.poppins(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() => selectedCategory = category);
                        },
                        selectedColor: const Color(0xFF4CAF50),
                        backgroundColor: Colors.white,
                        checkmarkColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: isSelected ? 0 : 2,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Content Cards
          Expanded(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: RefreshIndicator(
                      color: const Color(0xFF4CAF50),
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          for (var tip in tips) {
                            tip['isRead'] = false;
                          }
                          readTipsCount = 0;
                        });
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: getFilteredTips().length,
                        itemBuilder: (context, index) {
                          final tip = getFilteredTips()[index];
                          return Hero(
                            tag: 'tip_${tip['title']}',
                            child: Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () => toggleTipRead(index),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            tip['icon'],
                                            style: const TextStyle(fontSize: 24),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    tip['title'],
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                AnimatedSwitcher(
                                                  duration: const Duration(milliseconds: 300),
                                                  child: Icon(
                                                    tip['isRead']
                                                        ? Icons.check_circle
                                                        : Icons.check_circle_outline,
                                                    key: ValueKey<bool>(tip['isRead']),
                                                    color: tip['isRead']
                                                        ? const Color(0xFF4CAF50)
                                                        : Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              tip['summary'],
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Submit'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'Rewards'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
