import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'eco_action_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _selectedTimeRange = 'Week';
  final List<String> _timeRanges = ['Week', 'Month', 'Year'];

  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.directions_bike,
      'color': const Color(0xFF4CAF50),
      'title': 'Cycled to work',
      'time': 'Today',
      'co2': '-2.5 kg CO₂'
    },
    {
      'icon': Icons.shopping_bag,
      'color': Colors.blue,
      'title': 'Used reusable bags',
      'time': 'Yesterday',
      'co2': '-1.2 kg CO₂'
    },
    {
      'icon': Icons.water_drop,
      'color': Colors.purple,
      'title': 'Short shower',
      'time': '2 days ago',
      'co2': '-0.8 kg CO₂'
    },
    {
      'icon': Icons.park,
      'color': Colors.orange,
      'title': 'Planted a tree',
      'time': '4 days ago',
      'co2': '-3.0 kg CO₂'
    },
  ];

  List<FlSpot> _getChartData() {
    switch (_selectedTimeRange) {
      case 'Week':
        return [
          const FlSpot(0, 1.5),  // Monday
          const FlSpot(1, 2.8),  // Tuesday
          const FlSpot(2, 3.5),  // Wednesday
          const FlSpot(3, 4.2),  // Thursday
          const FlSpot(4, 5.0),  // Friday
          const FlSpot(5, 5.8),  // Saturday
          const FlSpot(6, 6.5),  // Sunday
        ];
      case 'Month':
        return [
          const FlSpot(0, 10.5), // Week 1
          const FlSpot(1, 15.8), // Week 2
          const FlSpot(2, 20.3), // Week 3
          const FlSpot(3, 25.7), // Week 4
        ];
      case 'Year':
        return [
          const FlSpot(0, 45.2),  // Jan
          const FlSpot(1, 52.1),  // Feb
          const FlSpot(2, 58.7),  // Mar
          const FlSpot(3, 65.3),  // Apr
          const FlSpot(4, 72.1),  // May
          const FlSpot(5, 78.4),  // Jun
          const FlSpot(6, 85.2),  // Jul
          const FlSpot(7, 92.8),  // Aug
          const FlSpot(8, 98.5),  // Sep
          const FlSpot(9, 105.2), // Oct
          const FlSpot(10, 112.6), // Nov
          const FlSpot(11, 120.9), // Dec
        ];
      default:
        return [];
    }
  }

  List<int> _getFilteredLabelIndexes() {
    switch (_selectedTimeRange) {
      case 'Week':
        return List.generate(7, (i) => i);
      case 'Month':
        return List.generate(4, (i) => i);
      case 'Year':
        return [0, 2, 4, 6, 8, 10];
      default:
        return [];
    }
  }

  String _getXAxisLabel(double value) {
    switch (_selectedTimeRange) {
      case 'Week':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return (value.toInt() >= 0 && value.toInt() < days.length) ? days[value.toInt()] : '';
      case 'Month':
        const weeks = ['W1', 'W2', 'W3', 'W4'];
        return (value.toInt() >= 0 && value.toInt() < weeks.length) ? weeks[value.toInt()] : '';
      case 'Year':
        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return (value.toInt() >= 0 && value.toInt() < months.length) ? months[value.toInt()] : '';
      default:
        return '';
    }
  }

  SideTitles _buildBottomTitles() {
    final indexesToShow = _getFilteredLabelIndexes();
    return SideTitles(
      showTitles: true,
      interval: 1,
      getTitlesWidget: (value, meta) {
        if (indexesToShow.contains(value.toInt())) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _getXAxisLabel(value),
              style: const TextStyle(fontSize: 10),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome back,',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Text(
              'Emma Johnson',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '2',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarbonFootprintSection(),
            const SizedBox(height: 32),
            _buildQuickStats(),
            const SizedBox(height: 32),
            _buildRecentActions(),
            const SizedBox(height: 32),
            _buildRewardsProgress(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildCarbonFootprintSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carbon Footprint',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _timeRanges.map((range) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: TextButton(
                      onPressed: () => setState(() => _selectedTimeRange = range),
                      style: TextButton.styleFrom(
                        backgroundColor: _selectedTimeRange == range ? const Color(0xFF4CAF50) : Colors.transparent,
                        foregroundColor: _selectedTimeRange == range ? Colors.white : Colors.grey[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(range),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(

              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: _selectedTimeRange == 'Week' ? 1.0 : 
                               _selectedTimeRange == 'Month' ? 5.0 : 20.0,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()} kg',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(sideTitles: _buildBottomTitles()),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: const Color(0xFF4CAF50),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 6,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF4CAF50),
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF4CAF50).withOpacity(0.3),
                          const Color(0xFF4CAF50).withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          'You saved ${barSpot.y.toStringAsFixed(1)} kg of CO₂',
                          const TextStyle(color: Colors.black),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
          Row(
          children: [
            _buildStatCard('Eco-Actions', '42', FontAwesomeIcons.leaf, const Color(0xFF4CAF50).withOpacity(0.1)),
            const SizedBox(width: 12),
            _buildStatCard('CO₂ Saved', '168 kg', FontAwesomeIcons.chartLine, Colors.blue.withOpacity(0.1)),
            const SizedBox(width: 12),
            _buildStatCard('Badges', '8', FontAwesomeIcons.medal, Colors.amber.withOpacity(0.1)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: FaIcon(icon, color: const Color(0xFF4CAF50), size: 20),
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Eco-Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(color: const Color(0xFF4CAF50), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _actions.length,
            separatorBuilder: (_, __) => Divider(color: Colors.grey[300]),
            itemBuilder: (context, index) {
              final action = _actions[index];
              return ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(action['icon'], color: action['color']),
                ),
                title: Text(action['title']),
                subtitle: Text(action['time'], style: TextStyle(color: Colors.grey[600])),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: action['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(action['co2'], style: TextStyle(color: action['color'])),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rewards Progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Level 2 - Eco Warrior', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Next Reward: Forest Guardian (750 points needed)', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  const Text('250/1000', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 16),
          LinearPercentIndicator(
                lineHeight: 8,
                percent: 0.25,
                backgroundColor: Colors.grey[200],
                progressColor: const Color(0xFF4CAF50),
                barRadius: const Radius.circular(4),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            // Navigate to EcoActionScreen when Add Action is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EcoActionScreen()),
            );
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'Add Action'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), activeIcon: Icon(Icons.emoji_events), label: 'Rewards'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), activeIcon: Icon(Icons.menu_book), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
