
# Mileage Tracker (Flutter)

Simple Android mileage tracker for odometer-based trips with optional GPS capture **on button press**. Classify as **Work** or **Personal**, keep free-text origin/destination, add a purpose, view monthly totals, and **export CSV**. Includes quick shortcuts for **Home** and **Office**.

## Quick Start

### Prereqs
- Flutter SDK installed
- Android Studio (SDK + platform tools)

### Clone & scaffold platforms
```bash
git clone <YOUR_REPO_URL>.git
cd mileage_tracker
flutter pub get
# If android/ios folders are missing (this repo ships only Dart code), generate them:
flutter create .
```

### Android permissions
Add these to `android/app/src/main/AndroidManifest.xml` inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
```

### Run on device
```bash
flutter run
```

## Build an installable APK (signed release)

1. Generate a keystore (one-time):
   ```bash
   keytool -genkey -v -keystore ~/mileage-keystore.jks -alias mileage -keyalg RSA -keysize 2048 -validity 10000
   ```
2. Create `android/key.properties`:
   ```
   storePassword=<your_password>
   keyPassword=<your_password>
   keyAlias=mileage
   storeFile=/ABSOLUTE/PATH/TO/mileage-keystore.jks
   ```
3. Edit `android/app/build.gradle` and add (inside `android {}`):
   ```gradle
   def keystorePropertiesFile = rootProject.file("key.properties")
   def keystoreProperties = new Properties()
   if (keystorePropertiesFile.exists()) {
       keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
   }

   signingConfigs {
       release {
           if (keystoreProperties['storeFile']) {
               storeFile file(keystoreProperties['storeFile'])
               storePassword keystoreProperties['storePassword']
               keyAlias keystoreProperties['keyAlias']
               keyPassword keystoreProperties['keyPassword']
           }
       }
   }

   buildTypes {
       release {
           signingConfig signingConfigs.release
           minifyEnabled false
           shrinkResources false
       }
   }
   ```
4. Build the APK:
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`.

> For a quick test without signing, you can do `flutter build apk --debug` and install the debug APK on your device.

## CSV Export
On the Trips screen, tap the share icon to generate a CSV for the current month and share it (email/Drive/etc.).

## Project structure
```
lib/
  main.dart
  models/trip.dart
  screens/
    new_trip.dart
    trip_list.dart
  storage/
    db.dart
    trips.dart
  utils/
    location.dart
    csv_export.dart
```

## Shortcuts
- Quick chips to set **Origin**/**Destination** to **Home** or **Office**.

---
MIT License
