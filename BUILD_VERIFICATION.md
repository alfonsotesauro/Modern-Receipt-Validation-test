# Build and Verification Instructions

This document provides step-by-step instructions for building, testing, and verifying the Modern Receipt Validation app.

## Prerequisites

### System Requirements
- macOS 14.0 (Sonoma) or later
- Xcode 15.0 or later
- Swift 5.9 or later
- Apple Developer account (for App Store distribution)

### Verify Installation

```bash
# Check macOS version
sw_vers

# Check Xcode installation
xcodebuild -version

# Check Swift version
swift --version
```

Expected output:
```
Xcode 15.0 or later
Swift version 5.9 or later
```

## Building the Project

### Method 1: Using Xcode (Recommended)

1. **Open the project:**
   ```bash
   cd Modern-Receipt-Validation-test
   open "Modern Receipt Test Alfonso.xcodeproj"
   ```

2. **Select the scheme:**
   - In Xcode, select "Modern Receipt Test Alfonso" from the scheme dropdown
   - Choose "My Mac" as the destination

3. **Build the project:**
   - Press `⌘B` or select Product > Build
   - Wait for build to complete

4. **Run the app:**
   - Press `⌘R` or select Product > Run
   - The app window should open

### Method 2: Using Command Line

#### Debug Build
```bash
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Debug \
           clean build
```

#### Release Build
```bash
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           clean build
```

#### Build Output Location
```bash
# Debug build
build/Debug/Modern Receipt Test Alfonso.app

# Release build  
build/Release/Modern Receipt Test Alfonso.app
```

### Method 3: Archive for Distribution

```bash
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           archive \
           -archivePath "build/ModernReceiptTestAlfonso.xcarchive"
```

## Running the App

### From Xcode
Simply press `⌘R` or click the Run button.

### From Command Line
```bash
open "build/Release/Modern Receipt Test Alfonso.app"
```

### From Finder
Navigate to the build folder and double-click the app icon.

## Expected Behavior

### Development Mode (No Receipt)

When running from Xcode or a local build, you'll see:

```
⚠️ Receipt Not Found
This app may be running in development mode or outside the App Store.
```

**This is expected behavior!** Development builds don't include App Store receipts.

### With Receipt (TestFlight/App Store)

When downloaded from TestFlight or the App Store:

```
✅ Valid Receipt
Bundle ID: com.alfonso.ModernReceiptTestAlfonso
Version: 1.0
```

## Verification Steps

### 1. Verify Project Structure

```bash
# Check all files are present
tree -L 3 "Modern Receipt Test Alfonso"
```

Expected structure:
```
Modern Receipt Test Alfonso
├── Assets.xcassets
│   ├── AccentColor.colorset
│   ├── AppIcon.appiconset
│   └── Contents.json
├── ContentView.swift
├── Info.plist
├── ModernReceiptTestAlfonsoApp.swift
├── Modern_Receipt_Test_Alfonso.entitlements
├── ObfuscationHelpers.swift
└── ReceiptValidator.swift
```

### 2. Verify Build Success

```bash
# Build and check for errors
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           -quiet \
           build 2>&1 | grep -i error
```

If successful, there should be no output.

### 3. Verify App Launch

```bash
# Launch app
open "build/Release/Modern Receipt Test Alfonso.app"

# Check if app process is running
ps aux | grep "Modern Receipt Test Alfonso"
```

### 4. Verify Obfuscation

Check that sensitive strings are not in plaintext:

```bash
# Build release version
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           clean build

# Extract strings from binary
strings "build/Release/Modern Receipt Test Alfonso.app/Contents/MacOS/Modern Receipt Test Alfonso" > /tmp/app_strings.txt

# Search for sensitive terms
echo "Checking for obfuscation..."
grep -i "receipt" /tmp/app_strings.txt | head -5
```

You should see minimal or no hardcoded "receipt" strings.

### 5. Test UI Functionality

Manual testing checklist:

- [ ] App window opens successfully
- [ ] Title "Modern Receipt Validation" is displayed
- [ ] Subtitle "with Code Obfuscation" is shown
- [ ] "Validate Receipt" button is visible
- [ ] Clicking the button triggers validation
- [ ] Result is displayed in the text area
- [ ] "About This App" section shows information
- [ ] Window can be resized
- [ ] App responds to interactions

### 6. Test Validation Logic

Run these tests in Xcode debugger:

```swift
// Test 1: Check receipt path construction
let validator = ReceiptValidator()
print("Receipt exists: \(validator.a1b2c3())")

// Test 2: Check obfuscation
let obfuscated = StringObfuscator.obfuscate("test")
let deobfuscated = StringObfuscator.deobfuscate(obfuscated)
assert(deobfuscated == "test", "Obfuscation failed")

// Test 3: Check anti-debug
print("Debugger attached: \(AntiDebug.isDebuggerAttached())")
// Should print "true" when running in debugger
```

## Testing with TestFlight

To test receipt validation with a real receipt:

### 1. Archive the App

In Xcode:
1. Select "Any Mac" as destination
2. Product > Archive
3. Wait for archive to complete
4. Organizer window will open

### 2. Distribute to TestFlight

1. Click "Distribute App"
2. Select "App Store Connect"
3. Click "Upload"
4. Follow the prompts to upload

### 3. Configure TestFlight

1. Go to App Store Connect
2. Select your app
3. Go to TestFlight tab
4. Add internal or external testers
5. Submit for beta review (if needed)

### 4. Download and Test

1. Install TestFlight on test Mac
2. Accept the invite
3. Download the app
4. Run the app
5. Should now see "✅ Valid Receipt"

## Troubleshooting

### Build Errors

**Error: "No such module 'SwiftUI'"**
- Solution: Ensure deployment target is macOS 14.0+
- Check: Project settings > Deployment Target

**Error: "Command CodeSign failed"**
- Solution: Select "Sign to Run Locally" in signing settings
- Or: Use a valid development certificate

### Runtime Errors

**App crashes on launch**
- Check Console.app for crash logs
- Verify all required frameworks are linked
- Ensure Info.plist is properly configured

**"Receipt Not Found" in TestFlight**
- Receipt may not be generated immediately
- Try: Restart the app
- Try: Re-download from TestFlight

### Receipt Validation Issues

**Always shows "Receipt Not Found"**
- Expected in development builds
- Must test with TestFlight or App Store build
- Cannot be simulated locally

**"Invalid Signature"**
- Receipt format may have changed
- Check ASN.1 parsing logic
- Verify Apple root certificate

**"Bundle ID Mismatch"**
- Receipt is from a different app
- Check bundle identifier in project settings
- Ensure matching with App Store Connect

## Performance Verification

### Check App Size

```bash
# Get app bundle size
du -sh "build/Release/Modern Receipt Test Alfonso.app"

# Get binary size
du -sh "build/Release/Modern Receipt Test Alfonso.app/Contents/MacOS/Modern Receipt Test Alfonso"
```

Expected sizes:
- App bundle: < 5 MB
- Binary: < 1 MB

### Check Launch Time

```bash
# Time the app launch
time open "build/Release/Modern Receipt Test Alfonso.app"
```

Should launch in under 2 seconds.

### Memory Usage

```bash
# Launch app and check memory
open "build/Release/Modern Receipt Test Alfonso.app"
sleep 2
ps aux | grep "Modern Receipt Test Alfonso" | grep -v grep | awk '{print $6/1024 " MB"}'
```

Expected memory usage: < 100 MB

## Code Quality Checks

### Swift Lint (if installed)

```bash
# Install SwiftLint if needed
brew install swiftlint

# Run linting
swiftlint lint "Modern Receipt Test Alfonso"
```

### Check for Hardcoded Secrets

```bash
# Search source files for potential secrets
grep -r "sk-" "Modern Receipt Test Alfonso/"
grep -r "api_key" "Modern Receipt Test Alfonso/"
grep -r "password" "Modern Receipt Test Alfonso/"
```

Should return no matches.

## Continuous Integration

### GitHub Actions Example

Create `.github/workflows/build.yml`:

```yaml
name: Build and Test

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-14
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Select Xcode version
      run: sudo xcode-select -s /Applications/Xcode_15.0.app
    
    - name: Build
      run: |
        xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
                   -scheme "Modern Receipt Test Alfonso" \
                   -configuration Release \
                   clean build
    
    - name: Verify Binary
      run: |
        test -f "build/Release/Modern Receipt Test Alfonso.app/Contents/MacOS/Modern Receipt Test Alfonso"
```

## Distribution Checklist

Before distributing to users:

- [ ] Build succeeds with no warnings
- [ ] All UI elements display correctly
- [ ] Validation logic works in TestFlight
- [ ] Obfuscation is verified
- [ ] App size is reasonable
- [ ] Performance is acceptable
- [ ] Documentation is complete
- [ ] Version number is updated
- [ ] Code signing is configured
- [ ] Privacy policy is prepared

## Support

For issues or questions:

1. Check the README.md for general information
2. Review OBFUSCATION_GUIDE.md for implementation details
3. Check Apple Developer documentation
4. Review App Store Connect status

## Version Verification

Current version information:

```bash
# Check version in Info.plist
/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "Modern Receipt Test Alfonso/Info.plist"

# Check build number
/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "Modern Receipt Test Alfonso/Info.plist"
```

Expected output:
- Version: 1.0
- Build: 1

## Next Steps

After successful verification:

1. **For Development**: Continue adding features
2. **For Testing**: Submit to TestFlight
3. **For Production**: Submit to App Store
4. **For Learning**: Review and modify the code

## Additional Notes

- Always test with real receipts via TestFlight
- Keep Apple's root certificate updated
- Monitor for changes in receipt format
- Update validation logic as needed
- Rotate obfuscation keys regularly

---

Last Updated: December 2024
