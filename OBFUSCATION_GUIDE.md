# Obfuscation Extension Guide

This document provides practical examples for extending the obfuscation techniques in this project.

## Quick Reference

### String Obfuscation Tool

Use this helper to generate obfuscated strings for your code:

```swift
// Run this in a Swift Playground or script to generate obfuscated values
import Foundation

func obfuscateString(_ input: String, key: UInt8 = 0x42) {
    let obfuscated = input.utf8.map { $0 ^ key }
    print("Original: \(input)")
    print("Obfuscated array: \(obfuscated)")
    print("Swift code:")
    print("let obfuscated: [UInt8] = \(obfuscated)")
    print("let deobfuscated = StringObfuscator.deobfuscate(obfuscated, key: 0x\(String(key, radix: 16)))")
}

// Examples:
obfuscateString("receipt")
obfuscateString("bundle.identifier")
obfuscateString("CFBundleVersion")
```

## Common Obfuscation Patterns

### 1. Obfuscating API Keys

**Never do this:**
```swift
let apiKey = "sk-1234567890abcdef"
```

**Do this instead:**
```swift
// Generated using obfuscateString("sk-1234567890abcdef")
private let obfuscatedAPIKey: [UInt8] = [0x31, 0x2b, 0x6d, 0x77, 0x75, 0x77, 0x75, 0x75, 0x79, 0x78, 0x74, 0x70, 0x64, 0x67, 0x67, 0x66, 0x67, 0x68]

func getAPIKey() -> String {
    return StringObfuscator.deobfuscate(obfuscatedAPIKey, key: 0x42)
}
```

### 2. Obfuscating URLs

**Never do this:**
```swift
let validationURL = "https://api.example.com/validate"
```

**Do this instead:**
```swift
// Split URL into parts
private let protocol_: [UInt8] = [0x2a, 0x34, 0x34, 0x32, 0x31] // "https"
private let domain: [UInt8] = [0x63, 0x32, 0x29, 0x6f, 0x27, 0x38, 0x63, 0x2f, 0x32, 0x2c, 0x27, 0x6f, 0x25, 0x2f, 0x2e] // "api.example.com"
private let path: [UInt8] = [0x78, 0x36, 0x63, 0x2c, 0x29, 0x26, 0x63, 0x34, 0x27] // "/validate"

func getValidationURL() -> String {
    let p = StringObfuscator.deobfuscate(protocol_, key: 0x42)
    let d = StringObfuscator.deobfuscate(domain, key: 0x42)
    let path = StringObfuscator.deobfuscate(self.path, key: 0x42)
    return "\(p)://\(d)\(path)"
}
```

### 3. Obfuscating Method Names for Critical Functions

```swift
// Create a protocol with cryptic names
protocol SecureValidation {
    func k8j9l0() -> Bool      // Actually: validateLicense
    func m3n4p5() -> Data?     // Actually: fetchServerResponse
    func q6r7s8() -> String    // Actually: computeHash
}

// Implement the protocol
extension MyValidator: SecureValidation {
    func k8j9l0() -> Bool {
        return performLicenseValidation()
    }
    
    func m3n4p5() -> Data? {
        return fetchValidationData()
    }
    
    func q6r7s8() -> String {
        return computeSecurityHash()
    }
}

// Usage
let validator = MyValidator()
if validator.k8j9l0() {
    print("Valid")
}
```

### 4. Control Flow Obfuscation Pattern

```swift
// Instead of simple if statements
func checkLicense() -> Bool {
    let hasValidLicense = performCheck()
    
    if hasValidLicense {
        return true
    }
    return false
}

// Use obfuscated control flow
func checkLicense() -> Bool {
    // Add junk variables
    let timestamp = Date().timeIntervalSince1970
    let randomValue = arc4random() % 1000
    
    // Perform actual check wrapped in noise
    let result = ControlFlowObfuscator.obfuscatedCheck(self) { validator in
        // More junk operations
        let _ = UUID().uuidString
        let check = validator.performCheck()
        let _ = Data(count: Int.random(in: 1...10))
        return check
    }
    
    // Add more noise after
    let _ = timestamp + Double(randomValue)
    
    return result
}
```

### 5. Data Obfuscation for Embedded Resources

```swift
// Instead of embedding data directly
let certificateData = Data(base64Encoded: "MIIBIjANBgkq...")!

// Obfuscate the data
private let obfuscatedCertData: [UInt8] = [
    // XOR encoded certificate bytes
    0x9C, 0x78, 0x54, 0x31, 0x12, // ... many more bytes
]

func getCertificateData() -> Data {
    let bytes = obfuscatedCertData.map { $0 ^ 0x7F }
    return Data(bytes)
}
```

### 6. Dynamic String Assembly

```swift
// Instead of complete strings
let message = "License validation failed"

// Build from parts at runtime
func getErrorMessage() -> String {
    let parts = [
        "License ",
        "validation ",
        "failed"
    ]
    
    // Obfuscate each part
    let obfuscatedParts = parts.map { part in
        StringObfuscator.obfuscate(part).map { $0 }
    }
    
    // Reconstruct at runtime
    let deobfuscated = obfuscatedParts.map { bytes in
        StringObfuscator.deobfuscate(bytes)
    }
    
    return deobfuscated.joined()
}
```

### 7. Key Derivation from App Properties

```swift
// Derive obfuscation keys dynamically
func getDynamicKey() -> UInt8 {
    let bundleId = Bundle.main.bundleIdentifier ?? ""
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    return KeyDerivation.deriveKey(from: [bundleId, version, build])
}

// Use dynamic key for deobfuscation
func getSecretWithDynamicKey() -> String {
    let key = getDynamicKey()
    return StringObfuscator.deobfuscate(obfuscatedSecret, key: key)
}
```

## Anti-Tampering Patterns

### 1. Check for Debugger

```swift
func performSecureOperation() {
    // Check before sensitive operations
    if AntiDebug.isDebuggerAttached() {
        // Fail gracefully or exit
        print("Debug environment detected")
        return
    }
    
    // Perform sensitive operation
    validateReceipt()
}
```

### 2. Environment Validation

```swift
func validateEnvironment() -> Bool {
    // Check for suspicious environment
    if AntiDebug.hasDebugEnvironment() {
        return false
    }
    
    // Check for jailbreak indicators
    let suspiciousPaths = [
        "/Applications/Cydia.app",
        "/usr/sbin/sshd",
        "/usr/bin/ssh"
    ]
    
    for path in suspiciousPaths {
        if FileManager.default.fileExists(atPath: path) {
            return false
        }
    }
    
    return true
}
```

### 3. Checksum Verification

```swift
// Verify code hasn't been modified
func verifyIntegrity() -> Bool {
    guard let executablePath = Bundle.main.executablePath else {
        return false
    }
    
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: executablePath)) else {
        return false
    }
    
    // Compute hash of executable
    var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    data.withUnsafeBytes {
        _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
    }
    
    // Compare with known good hash (obfuscated)
    let expectedHash: [UInt8] = [/* obfuscated expected hash */]
    
    return hash == expectedHash.map { $0 ^ 0x42 }
}
```

## Multi-Layer Obfuscation

Combine multiple techniques for stronger protection:

```swift
class SecureValidator {
    // Layer 1: Obfuscated storage
    private let key1: [UInt8] = [0x31, 0x2b, 0x6d, /* ... */]
    private let key2: [UInt8] = [0x77, 0x75, 0x77, /* ... */]
    
    // Layer 2: Obfuscated method names
    func a1() -> String {
        return StringObfuscator.deobfuscate(key1, key: getDynamicKey())
    }
    
    // Layer 3: Control flow obfuscation
    func b2() -> Bool {
        let _ = arc4random()
        
        let result = ControlFlowObfuscator.obfuscatedCheck(a1()) { str in
            let _ = Date()
            let check = !str.isEmpty
            let _ = UUID()
            return check
        }
        
        let _ = Data(count: 10)
        return result
    }
    
    // Layer 4: Anti-debug
    func c3() -> Bool {
        if AntiDebug.isDebuggerAttached() {
            return false
        }
        return b2()
    }
    
    // Layer 5: Dynamic key derivation
    private func getDynamicKey() -> UInt8 {
        return KeyDerivation.bundleBasedKey()
    }
}
```

## Build-Time Obfuscation

### Using Build Scripts

Add a build phase script to Xcode to rotate obfuscation keys:

```bash
#!/bin/bash

# Generate random key
KEY=$(openssl rand -hex 1)

# Update obfuscation key in source
sed -i '' "s/key: 0x[0-9A-Fa-f]*/key: 0x$KEY/g" "ObfuscationHelpers.swift"

# Re-obfuscate strings with new key
# ... add your string obfuscation logic here
```

## Testing Obfuscation

### Verify Strings Are Not Plaintext

```bash
# Build the app
xcodebuild -project "Modern Receipt Test Alfonso.xcodeproj" \
           -scheme "Modern Receipt Test Alfonso" \
           -configuration Release \
           build

# Search for sensitive strings
strings "build/Release/Modern Receipt Test Alfonso.app/Contents/MacOS/Modern Receipt Test Alfonso" | grep -i "receipt"

# Should return very few or no matches if obfuscation is working
```

### Test Anti-Debug Features

```swift
func testAntiDebug() {
    print("Debugger attached: \(AntiDebug.isDebuggerAttached())")
    print("Debug env: \(AntiDebug.hasDebugEnvironment())")
}
```

## Production Checklist

Before shipping with obfuscation:

- [ ] All sensitive strings are obfuscated
- [ ] API keys and secrets use dynamic deobfuscation
- [ ] Critical methods use aliased names
- [ ] Control flow obfuscation is applied
- [ ] Anti-debug checks are in place
- [ ] Code is compiled with optimization flags
- [ ] Symbols are stripped from release build
- [ ] Bitcode is enabled (if applicable)
- [ ] Server-side validation is implemented
- [ ] Regular security audits are scheduled

## Additional Resources

- **LLVM Obfuscator**: https://github.com/obfuscator-llvm/obfuscator
- **SwiftShield**: https://github.com/rockbruno/swiftshield
- **iXGuard**: https://www.guardsquare.com/ixguard
- **OWASP Mobile Security**: https://owasp.org/www-project-mobile-security/

## Notes

Remember: Obfuscation is **not** encryption. It makes reverse engineering harder but not impossible. Always combine with:

1. Server-side validation
2. Regular updates
3. Multiple security layers
4. Monitoring and analytics
5. Legal protections (license agreements)

The goal is to make the cost of cracking higher than the benefit.
