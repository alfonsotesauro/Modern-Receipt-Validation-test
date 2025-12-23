# Modern Receipt Validation Test - Alfonso

A minimal macOS application demonstrating modern App Store receipt validation with code obfuscation techniques.

## Overview

This project serves as a comprehensive example of:
- **Modern Receipt Validation**: Local receipt parsing using ASN.1 and cryptographic signature verification
- **Code Obfuscation**: Multiple layers of obfuscation to protect sensitive logic from reverse engineering
- **macOS Best Practices**: SwiftUI app structure following modern macOS development patterns

## Features

### 1. Receipt Validation
- ✅ Local receipt validation without server dependencies
- ✅ ASN.1/DER format parsing
- ✅ PKCS#7 signature verification structure
- ✅ Bundle identifier verification
- ✅ Version checking
- ✅ Receipt existence detection

### 2. Code Obfuscation Techniques

#### String Obfuscation
- XOR-based encryption for sensitive strings
- Runtime deobfuscation
- Prevents static analysis of hardcoded values

#### Method Aliasing
- Cryptic method names (e.g., `a1b2c3()`, `x7y8z9()`)
- Protocol-based obfuscation
- Hides actual method purposes from disassemblers

#### Control Flow Obfuscation
- Junk operations inserted into critical paths
- Random timing delays
- Complex conditional structures

#### Dynamic String Building
- Character code-based string construction
- Runtime string assembly
- Reverse obfuscation patterns

#### Anti-Debug Measures
- Debugger attachment detection
- Environment variable checks
- Protects against runtime analysis

## Project Structure

```
Modern Receipt Test Alfonso/
├── ModernReceiptTestAlfonsoApp.swift    # App entry point
├── ContentView.swift                     # Main UI with validation display
├── ReceiptValidator.swift                # Receipt validation logic
├── ObfuscationHelpers.swift             # Obfuscation utilities
├── Assets.xcassets/                     # App assets
├── Info.plist                           # App configuration
└── Modern_Receipt_Test_Alfonso.entitlements  # Security entitlements
```

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Building the Project

### Using Xcode

1. Open the project:
   ```bash
   open "Modern Receipt Test Alfonso.xcodeproj"
   ```

2. Select the "Modern Receipt Test Alfonso" scheme

3. Build and run (⌘R)

### Using Command Line

```bash
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           clean build
```

## Usage

### Running the App

When you launch the app, it will automatically:
1. Check for the presence of an App Store receipt
2. Parse the receipt structure
3. Verify the signature (structure demonstration)
4. Display validation results in the UI

### Expected Behavior

**Development Mode (No Receipt)**:
```
⚠️ Receipt Not Found
This app may be running in development mode or outside the App Store.
```

**With Valid Receipt**:
```
✅ Valid Receipt
Bundle ID: com.alfonso.ModernReceiptTestAlfonso
Version: 1.0
```

**Invalid Receipt**:
```
❌ Invalid Receipt
Reason: [Specific validation failure]
```

## Obfuscation Deep Dive

### String Obfuscation Example

**Before Obfuscation:**
```swift
let receiptPath = "receipt"
```

**After Obfuscation:**
```swift
// XOR encrypted with key 0x42
let obfuscatedPath: [UInt8] = [0x30, 0x27, 0x25, 0x27, 0x29, 0x32, 0x34]
let receiptPath = StringObfuscator.deobfuscate(obfuscatedPath, key: 0x42)
```

### Method Aliasing Example

**Before:**
```swift
func checkReceiptExists() -> Bool { ... }
```

**After:**
```swift
// Protocol with obfuscated names
protocol ObfuscatedOperations {
    func a1b2c3() -> Bool  // Actually checks receipt existence
}
```

### Control Flow Example

**Before:**
```swift
if receiptExists {
    validateReceipt()
}
```

**After:**
```swift
if ControlFlowObfuscator.obfuscatedCheck(self) { obj in
    let _ = arc4random() % 1000  // Junk operation
    let result = obj.receiptExists()
    let _ = UUID().uuidString    // More junk
    return result
} {
    validateReceipt()
}
```

## Extending Obfuscation

### Adding Custom String Obfuscation

```swift
// 1. Obfuscate your string
let mySecret = "sensitive_data"
let obfuscated = StringObfuscator.obfuscate(mySecret, key: 0x42)
print(obfuscated)  // [115, 103, 110, 115, 105, 116, 105, 118, 107, ...]

// 2. Store obfuscated bytes in code
let obfuscatedSecret: [UInt8] = [115, 103, 110, 115, 105, 116, 105, 118, 107, ...]

// 3. Deobfuscate at runtime
let secret = StringObfuscator.deobfuscate(obfuscatedSecret, key: 0x42)
```

### Adding Method Aliasing

```swift
// 1. Define protocol with cryptic names
protocol SecureOps {
    func z9x8c7() -> Bool
}

// 2. Implement with actual logic
extension MyClass: SecureOps {
    func z9x8c7() -> Bool {
        return performSensitiveCheck()
    }
}

// 3. Use aliased method
let result = myInstance.z9x8c7()
```

### Adding Control Flow Obfuscation

```swift
// Wrap critical operations
let isValid = ControlFlowObfuscator.obfuscatedCheck(data) { d in
    // Your actual validation logic here
    return validateData(d)
}
```

## Production Recommendations

### For Serious Production Use:

1. **Use Commercial Obfuscators**:
   - iXGuard
   - Arxan
   - DexGuard (for cross-platform)

2. **Implement Server-Side Validation**:
   - Never rely solely on local validation
   - Use Apple's verifyReceipt API
   - Implement your own validation server

3. **Add More Security Layers**:
   - Certificate pinning
   - Runtime integrity checks
   - Anti-tampering detection
   - Jailbreak detection
   - Code signing verification

4. **Use Proper ASN.1 Parsing**:
   - Integrate SwiftASN1 or similar libraries
   - Parse full PKCS#7 structure
   - Verify complete certificate chain

5. **Embed Apple Root Certificate**:
   - Download from: https://www.apple.com/certificateauthority/
   - Embed in app bundle
   - Use for signature verification

6. **Implement Receipt Refresh**:
   - Call `SKReceiptRefreshRequest` if receipt missing
   - Handle refresh failures gracefully
   - Re-validate after refresh

7. **Add Subscription Handling**:
   - Parse subscription receipts
   - Check expiration dates
   - Validate auto-renewable subscriptions
   - Handle grace periods

8. **Use LLVM Obfuscation**:
   - Enable bitcode obfuscation
   - Use LLVM obfuscator passes
   - Compile with optimization flags

## Security Considerations

⚠️ **Important Security Notes**:

1. This is a **demonstration project** showing structure and techniques
2. Real production apps need **server-side validation**
3. Local validation alone can be bypassed by determined attackers
4. Obfuscation makes reverse engineering harder but not impossible
5. Always combine multiple security layers
6. Keep validation logic updated as iOS/macOS evolves
7. Monitor for piracy and respond appropriately

## Testing

### Development Testing
```bash
# Run in Xcode debugger
# Expected: "Receipt Not Found" message (no receipt in dev mode)
```

### App Store Testing
1. Archive the app
2. Submit to TestFlight or App Store
3. Download from TestFlight/App Store
4. Receipt should be present and validate correctly

### Manual Receipt Testing
You can test with a receipt file by:
1. Obtaining a valid receipt from App Store build
2. Placing it in: `YourApp.app/Contents/_MASReceipt/receipt`
3. Running validation

## Troubleshooting

### "Receipt Not Found"
- **Normal in development**: Xcode builds don't include receipts
- **Solution**: Test with TestFlight or App Store build

### "Invalid Signature"
- **Cause**: Receipt parsing or verification logic issue
- **Solution**: Check receipt format, ensure proper ASN.1 parsing

### "Bundle ID Mismatch"
- **Cause**: Receipt from different app
- **Solution**: Ensure using receipt from correct app bundle

## License

This project is provided as-is for educational and demonstration purposes.

## Author

Alfonso Tesauro

## Resources

- [Apple Receipt Validation Guide](https://developer.apple.com/documentation/appstorereceipts/validating_receipts_on_the_device)
- [Apple In-App Purchase Documentation](https://developer.apple.com/in-app-purchase/)
- [ASN.1 Specification](https://www.itu.int/rec/T-REC-X.690/)
- [PKCS#7 Standard](https://www.rfc-editor.org/rfc/rfc2315)
- [Code Obfuscation Best Practices](https://owasp.org/www-community/controls/Obfuscation)

## Version History

### 1.0.0 (2024)
- Initial release
- Basic receipt validation structure
- Multi-layer obfuscation implementation
- SwiftUI interface
- Documentation and examples
