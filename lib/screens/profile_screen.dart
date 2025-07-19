import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  final TextEditingController _nameController = TextEditingController(text: 'John Doe');
  final TextEditingController _emailController = TextEditingController(text: 'john.doe@example.com');

  // Sample data for the contribution chart
  final List<FlSpot> contributionData = [
    FlSpot(0, 2),
    FlSpot(1, 4),
    FlSpot(2, 3),
    FlSpot(3, 5),
    FlSpot(4, 4),
    FlSpot(5, 6),
    FlSpot(6, 5),
  ];

  final List<Map<String, dynamic>> badges = [
    {
      'name': 'Tree Planter',
      'icon': Icons.park,
      'description': 'Planted 5 trees',
      'unlocked': true,
    },
    {
      'name': 'Energy Saver',
      'icon': Icons.lightbulb_outline,
      'description': 'Reduced energy consumption by 20%',
      'unlocked': true,
    },
    {
      'name': 'Waste Warrior',
      'icon': Icons.delete_outline,
      'description': 'Zero waste for 30 days',
      'unlocked': false,
    },
    {
      'name': 'Water Guardian',
      'icon': Icons.water_drop_outlined,
      'description': 'Saved 1000L of water',
      'unlocked': true,
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildUserDetails(),
            _buildAchievements(),
            _buildContributionChart(),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green.shade200,
            Colors.green.shade50,
          ],
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/leaf_pattern.png'),
          opacity: 0.1,
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: const AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18),
                        onPressed: () {
                          // Implement image picker
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (isEditing) ...[_buildEditableFields()] else ...[_buildUserInfo()],
          const SizedBox(height: 24),
          _buildEcoScore(),
        ],
      ),
    );
  }

  Widget _buildEditableFields() {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          _nameController.text,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _emailController.text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEcoScore() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eco-Score',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Eco-Warrior',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      '42',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.park, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                '24 Actions Taken',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: badges.length,
            itemBuilder: (context, index) {
              final badge = badges[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Tooltip(
                  message: badge['description'],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        badge['icon'],
                        size: 32,
                        color: badge['unlocked'] ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        badge['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContributionChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Contributions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 7,
                  lineBarsData: [
                    LineChartBarData(
                      spots: contributionData,
                      isCurved: true,
                      color: Colors.green.shade300,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.green.shade50,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isEditing ? 'Save Profile' : 'Edit Profile',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/actions');
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'My Actions',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Settings',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton(
            onPressed: () {
              // Implement logout functionality
            },
            child: Text(
              'Logout',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red[400],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}