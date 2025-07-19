import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' show pi;

class RewardsScreen extends StatefulWidget {
  static const String routeName = '/rewards';

  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pointsController;
  late Animation<double> _pointsAnimation;
  late ConfettiController _confettiController;

  final int _currentPoints = 540;
  final int _nextMilestone = 1000;

  final List<Map<String, dynamic>> badges = [
    {
      'name': 'Green Starter',
      'description': 'Begin your eco-journey',
      'icon': Icons.eco,
      'unlocked': true,
      'color': Colors.green,
    },
    {
      'name': 'Water Saver',
      'description': 'Save 100L of water',
      'icon': Icons.water_drop,
      'unlocked': true,
      'color': Colors.blue,
    },
    {
      'name': 'Energy Guardian',
      'description': 'Reduce energy consumption',
      'icon': Icons.bolt,
      'unlocked': false,
      'color': Colors.yellow,
    },
    {
      'name': 'Recycling Pro',
      'description': 'Recycle 50 items',
      'icon': Icons.recycling,
      'unlocked': false,
      'color': Colors.orange,
    },
    {
      'name': 'Tree Planter',
      'description': 'Plant your first tree',
      'icon': Icons.park,
      'unlocked': false,
      'color': Colors.green[700],
    },
    {
      'name': 'Eco Warrior',
      'description': 'Complete 10 actions',
      'icon': Icons.military_tech,
      'unlocked': false,
      'color': Colors.purple,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pointsController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pointsAnimation = Tween<double>(
      begin: 0,
      end: _currentPoints.toDouble(),
    ).animate(CurvedAnimation(
      parent: _pointsController,
      curve: Curves.easeOut,
    ));

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );

    _pointsController.forward();
  }

  @override
  void dispose() {
    _pointsController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: 0,
                floating: false,
                pinned: true,
                elevation: 0,
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Eco Journey',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Every action counts for our planet ✨',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Stack(
                               alignment: Alignment.center,
                               children: [
                                 SizedBox(
                                   width: 220,
                                   height: 220,
                                   child: CircularProgressIndicator(
                                     value: _currentPoints / _nextMilestone,
                                     strokeWidth: 16,
                                     backgroundColor: Colors.grey[200],
                                     valueColor: AlwaysStoppedAnimation<Color>(
                                       const Color(0xFF4CAF50).withOpacity(0.8),
                                     ),
                                   ),
                                 ),
                                 Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   children: [
                                     const Icon(
                                       Icons.military_tech,
                                       color: Color(0xFF4CAF50),
                                       size: 40,
                                     ),
                                     const SizedBox(height: 12),
                                     AnimatedBuilder(
                                       animation: _pointsAnimation,
                                       builder: (context, child) {
                                         return Text(
                                           '${_pointsAnimation.value.toInt()}',
                                           style: GoogleFonts.poppins(
                                             fontSize: 48,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.black87,
                                           ),
                                         );
                                       },
                                     ),
                                     Text(
                                       'Points Earned',
                                       style: GoogleFonts.poppins(
                                         fontSize: 18,
                                         color: Colors.grey[600],
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                             const SizedBox(height: 32),
                             Text(
                               '460 points until next milestone',
                               style: GoogleFonts.poppins(
                                 fontSize: 18,
                                 color: Colors.grey[600],
                               ),
                             ),
                             const SizedBox(height: 16),
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                               decoration: BoxDecoration(
                                 color: const Color(0xFFFFF3E0),
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               child: Text(
                                 'Level 4',
                                 style: GoogleFonts.poppins(
                                   fontSize: 16,
                                   fontWeight: FontWeight.w500,
                                   color: Colors.orange[800],
                                 ),
                               ),
                             ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress to Next Milestone',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _currentPoints / _nextMilestone,
                          minHeight: 12,
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_nextMilestone - _currentPoints} points to Tree Plant Badge',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Your Badges',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: badges.length,
                        itemBuilder: (context, index) {
                          final badge = badges[index];
                          return Card(
                            elevation: badge['unlocked'] ? 4 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: badge['unlocked']
                                        ? badge['color']?.withOpacity(0.1)
                                        : Colors.grey[100],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          badge['icon'],
                                          size: 40,
                                          color: badge['unlocked']
                                              ? badge['color']
                                              : Colors.grey[400],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          badge['name'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: badge['unlocked']
                                                ? Colors.black87
                                                : Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          badge['description'],
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (!badge['unlocked'])
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Icon(
                                      Icons.lock,
                                      size: 20,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.emoji_events,
                                  color: Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Coming Soon: Eco-League Rankings',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Compete with other eco-warriors and earn special rewards! Stay tuned for community challenges.',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: -pi / 2,
              maxBlastForce: 5,
              minBlastForce: 2,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
    );
  }
}