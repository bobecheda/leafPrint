# LeafPrint
LeafPrint is a Flutter-based mobile application designed to help users track their carbon footprint, engage in eco-friendly actions, and earn rewards for sustainable living. The app aims to promote environmental awareness and empower users to reduce their environmental impact through actionable insights and gamification.

## Sustainable Development Goals (SDGs) Alignment
- SDG 11: Sustainable Cities and Communities
- SDG 12: Responsible Consumption and Production
- SDG 13: Climate Action
## Tech Stack
- Flutter for cross-platform mobile app development
- Firebase for backend services including Authentication and Firestore
- Google Sign-In for authentication
- fl_chart for data visualization
- Various Flutter packages for UI enhancements (google_fonts, font_awesome_flutter, percent_indicator, lottie, confetti, image_picker, dotted_border, intl)
## Features (MVP)
- User Authentication (Email/Password and Google Sign-In)
- Dashboard with carbon footprint tracking and visual charts
- Logging of eco-actions with CO₂ reduction tracking
- Educational Hub with sustainability resources
- Rewards system with points, badges, and levels
- User Profile management with stats and achievements
## Getting Started
### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Firebase account
- Android Studio or VS Code
### Installation
1. Clone the repository:
```
git clone https://github.com/
yourusername/leafprint.git
cd leafprint
```
2. Install dependencies:
```
flutter pub get
```
3. Configure Firebase:
- Create a Firebase project
- Add Android and iOS apps
- Download and add google-services.json (Android) and GoogleService-Info.plist (iOS) to respective directories
4. Run the app:
```
flutter run
```
## Project Structure
```
lib/
├── firebase_options.
dart       # Firebase 
configuration
├── main.
dart                  # App 
entry point
├── 
screens/                   # 
UI screens
│   ├── dashboard_screen.dart
│   ├── eco_action_screen.dart
│   ├── 
educational_hub_screen.dart
│   ├── login_screen.dart
│   ├── profile_screen.dart
│   ├── register_screen.dart
│   └── rewards_screen.dart
└── 
services/                  # 
Business logic and services
    ├── auth_service.
    dart      # 
    Authentication service
    └── navigation_service.
    dart
```
## Screenshots
Screenshots and demo videos will be added soon.

## Deployment
The web version of LeafPrint is deployed on Netlify: (https://coruscating-melomakarona-a3ef48.netlify.app/)
Make sure to register using your details then go back to login and login

## Dependencies
- firebase_core: ^2.32.0
- firebase_auth: ^4.20.0
- google_sign_in: ^6.2.1
- cloud_firestore: ^4.17.5
- google_fonts: ^6.1.0
- fl_chart: ^0.65.0
- font_awesome_flutter: ^10.6.0
- percent_indicator: ^4.2.3
- lottie: ^2.7.0
- confetti: ^0.7.0
- image_picker: ^1.0.4
- dotted_border: ^2.1.0
- intl: ^0.18.1
## Contributing
Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch ( git checkout -b feature/your-feature )
3. Commit your changes ( git commit -m 'Add your feature' )
4. Push to the branch ( git push origin feature/your-feature )
5. Open a Pull Request
## License
This project is licensed under the MIT License. See the LICENSE file for details.

## About LeafPrint
LeafPrint was created to empower individuals to make environmentally conscious decisions by providing tools to track and reduce their carbon footprint. Through education, tracking, and rewards, LeafPrint aims to build a community dedicated to sustainability and climate action
