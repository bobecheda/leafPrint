import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:confetti/confetti.dart';
import 'dart:io';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dotted_border/dotted_border.dart';


class EcoActionScreen extends StatefulWidget {
  const EcoActionScreen({super.key});

  @override
  State<EcoActionScreen> createState() => _EcoActionScreenState();
}

class _EcoActionScreenState extends State<EcoActionScreen> with TickerProviderStateMixin {
  int _currentStep = 0;
  String? _selectedCategory;
  late AnimationController _impactController;
  late Animation<double> _impactAnimation;
  late ConfettiController _confettiController;
  late AnimationController _checkmarkController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _pointsAnimation;
  double _co2Impact = 0.0;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  final _formKey = GlobalKey<FormState>();
  bool _isDescriptionValid = false;
  bool _isLocationValid = false;
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(_validateDescription);
    _locationController.addListener(_validateLocation);
    
    _impactController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pageController.addListener(() {
      // Prevent manual page swipe
      if (_pageController.page?.round() != _currentStep) {
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
    
    _impactAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _impactController,
      curve: Curves.easeOutCubic,
    ));

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));

    _pointsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.easeOutBack,
    ));
  }
  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _descriptionFocus.dispose();
    _locationFocus.dispose();
    _impactController.dispose();
    _confettiController.dispose();
    _checkmarkController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildSuccessScreen() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _checkmarkAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Thank you for taking action 🌱',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Every step counts toward a greener future.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _pointsAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Color(0xFFFFC107),
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '+20 Points Earned',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.7,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '70/100 points to next badge',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Share your impact',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedImage != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 120,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            const SizedBox(height: 12),
                            Text(
                              _selectedCategory ?? 'Eco Action',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_categories.firstWhere((cat) => cat["name"] == _selectedCategory, orElse: () => _categories[0])["co2Impact"].toString()} kg CO₂ saved',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: const Color(0xFF4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildShareButton(
                            icon: FontAwesomeIcons.whatsapp,
                            label: 'WhatsApp',
                            onTap: () {
                              // TODO: Implement WhatsApp sharing
                            },
                          ),
                          _buildShareButton(
                            icon: Icons.camera_alt,
                            label: 'Instagram',
                            onTap: () {
                              // TODO: Implement Instagram sharing
                            },
                          ),
                          _buildShareButton(
                            icon: Icons.copy,
                            label: 'Copy',
                            onTap: () {
                              // TODO: Implement copy to clipboard
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
            shouldLoop: false,
            colors: const [
              Color(0xFF4CAF50),
              Color(0xFF81C784),
              Color(0xFFA5D6A7),
              Colors.white,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildShareButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade700),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImpactSummary() {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _currentStep == 2 ? 1.0 : 0.0,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  '🌍 You saved',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _impactAnimation,
                  builder: (context, child) {
                    final category = _categories.firstWhere(
                      (cat) => cat['name'] == _selectedCategory,
                      orElse: () => _categories[0],
                    );
                    final impact = category['co2Impact'] * _impactAnimation.value;
                    return Text(
                      '${impact.toStringAsFixed(1)} kg',
                      style: GoogleFonts.poppins(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4CAF50),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'of CO₂ emissions',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.electric_bolt,
                            color: Color(0xFF4CAF50),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.phone_iphone,
                            color: Color(0xFF4CAF50),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'That\'s equivalent to charging\nyour phone 300 times!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: math.pi / 2,
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 50,
            gravity: 0.1,
            shouldLoop: false,
            colors: const [
              Color(0xFF4CAF50),
              Color(0xFF81C784),
              Color(0xFFA5D6A7),
              Colors.white,
            ],
          ),
        ),
      ],
    );
  }

  void _validateDescription() {
    setState(() {
      _isDescriptionValid = _descriptionController.text.length >= 10 &&
          _descriptionController.text.length <= 200;
    });
  }

  void _validateLocation() {
    setState(() {
      _isLocationValid = _locationController.text.isNotEmpty;
    });
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      if (_currentStep == 0 && _selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a category')),
        );
        return;
      }
      setState(() {
        _currentStep++;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        if (_currentStep == 2) {
          _impactController.reset();
          _impactController.forward();
        } else if (_currentStep == 3) {
          _checkmarkController.reset();
          _checkmarkController.forward();
          _confettiController.play();
          HapticFeedback.mediumImpact();
        }
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Recycling',
      'icon': Icons.recycling,
      'color': Colors.blue,
      'co2Impact': 2.1,
    },
    {
      'name': 'Tree Planting',
      'icon': Icons.park,
      'color': Colors.green,
      'co2Impact': 5.4,
    },
    {
      'name': 'Walking/Cycling',
      'icon': Icons.directions_bike,
      'color': Colors.orange,
      'co2Impact': 1.8,
    },
    {
      'name': 'Eco-shopping',
      'icon': Icons.shopping_bag,
      'color': Colors.purple,
      'co2Impact': 1.2,
    },
    {
      'name': 'Energy Saving',
      'icon': Icons.lightbulb_outline,
      'color': Colors.amber,
      'co2Impact': 3.2,
    },
    {
      'name': 'Water Conservation',
      'icon': Icons.water_drop,
      'color': Colors.lightBlue,
      'co2Impact': 1.5,
    },
  ];

  Widget _buildCategorySelection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select an Eco-Action',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'What kind of eco-action are you submitting?',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];

                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 200),
                  tween: Tween(begin: 1.0, end: isSelected ? 0.95 : 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category['color'].withOpacity(0.1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? category['color']
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: category['color'].withOpacity(0.2),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                              : [],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() {
                                _selectedCategory = category['name'];
                              });
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? category['color'].withOpacity(0.1)
                                          : Colors.grey.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      category['icon'],
                                      size: 40,
                                      color: category['color'],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    category['name'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? category['color']
                                          : Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  AnimatedOpacity(
                                    duration: const Duration(milliseconds: 300),
                                    opacity: isSelected ? 1.0 : 0.0,
                                    child: Icon(
                                      Icons.check_circle,
                                      color: category['color'],
                                      size: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade200,
            border: Border.all(
              color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: GoogleFonts.poppins(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade600,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider(bool isActive) {
    return Container(
      width: 32,
          height: 1.5,
      color: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade200,
    );
  }

  Widget _buildDetailsForm() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _currentStep == 1 ? 1.0 : 0.0,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Describe your ${_selectedCategory?.toLowerCase() ?? "eco-action"}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                focusNode: _descriptionFocus,
                maxLines: 4,
                maxLength: 200,
                decoration: InputDecoration(
                  labelText: 'Action Description',
                  border: const OutlineInputBorder(),
                  helperText: 'Describe what you did (10-200 characters)',
                  errorStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: _isDescriptionValid
                      ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50))
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  if (value.length > 200) {
                    return 'Description must not exceed 200 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  _validateDescription();
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _locationController,
                focusNode: _locationFocus,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: const OutlineInputBorder(),
                  helperText: 'Where did this action take place?',
                  errorStyle: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: _isLocationValid
                      ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50))
                      : null,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Location is required';
                  }
                  if (value.length < 3) {
                    return 'Location must be at least 3 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  _validateLocation();
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a photo (optional)',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickImage,
                    child: _selectedImage == null
                        ? DottedBorder(
                            color: Colors.grey.shade400,
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [6, 3],

                            child: Container(
                              width: double.infinity,
                              height: 150,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate_outlined, 
                                    size: 48, 
                                    color: Colors.grey.shade600
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add a photo',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        : Stack(
                            alignment: Alignment.topRight,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      _selectedImage = null;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentStep > 0) {
          _previousStep();
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Eco Action", style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF4CAF50),
          leading: _currentStep > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _previousStep,
                )
              : null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / 4,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStepIndicator(0, 'Category', _currentStep >= 0),
                  _buildStepDivider(_currentStep >= 1),
                  _buildStepIndicator(1, 'Details', _currentStep >= 1),
                  _buildStepDivider(_currentStep >= 2),
                  _buildStepIndicator(2, 'Impact', _currentStep >= 2),
                  _buildStepDivider(_currentStep >= 3),
                  _buildStepIndicator(3, 'Success', _currentStep >= 3),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                    if (index == 2) {
                      _impactController.reset();
                      _impactController.forward();
                      _confettiController.play();
                      HapticFeedback.mediumImpact();
                    } else if (index == 3) {
                      _checkmarkController.reset();
                      _checkmarkController.forward();
                      _confettiController.play();
                      HapticFeedback.mediumImpact();
                    }
                  });
                },
                children: [
                  _buildCategorySelection(),
                  _buildDetailsForm(),
                  _buildImpactSummary(),
                  _buildSuccessScreen(),
                ],
              ),
            ),
          ],
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
child: ElevatedButton(
  onPressed: (
    (_currentStep == 0 && _selectedCategory == null) ||
    (_currentStep == 1 && !(_isDescriptionValid && _isLocationValid))
  )
      ? null
      : () async {
          if (_currentStep == 0 && _selectedCategory != null) {
            _nextStep();
          } else if (_currentStep == 1 && _formKey.currentState?.validate() == true) {
            _nextStep();
          } else if (_currentStep == 2) {
            await Future.delayed(const Duration(milliseconds: 500));
            _nextStep();
          } else if (_currentStep == 3) {
            Navigator.of(context).pop(); // Return to dashboard
          }
        },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              disabledForegroundColor: Colors.white.withOpacity(0.5),
              disabledBackgroundColor: Colors.transparent,
            ),

            child: Text(
              _currentStep == 0 ? 'Next' : 
              _currentStep == 1 ? 'Calculate Impact' : 
              _currentStep == 2 ? 'Submit Action' : 
              'Back to Dashboard',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

          
