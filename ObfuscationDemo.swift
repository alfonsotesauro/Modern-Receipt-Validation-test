#!/usr/bin/env swift
//
// ObfuscationDemo.swift
// Demonstration script for string obfuscation
//
// Usage: 
//   Interactive mode: swift ObfuscationDemo.swift
//   Run all demos:    swift ObfuscationDemo.swift --all
//   Show help:        swift ObfuscationDemo.swift --help
//

import Foundation

// MARK: - Obfuscation Utilities

struct StringObfuscator {
    static func obfuscate(_ string: String, key: UInt8 = 0x42) -> [UInt8] {
        return string.utf8.map { $0 ^ key }
    }
    
    static func deobfuscate(_ bytes: [UInt8], key: UInt8 = 0x42) -> String {
        let decodedBytes = bytes.map { $0 ^ key }
        return String(bytes: decodedBytes, encoding: .utf8) ?? ""
    }
}

// MARK: - Demo Functions

func printHeader(_ title: String) {
    print("\n" + String(repeating: "=", count: 60))
    print(" \(title)")
    print(String(repeating: "=", count: 60) + "\n")
}

func demoBasicObfuscation() {
    printHeader("Demo 1: Basic String Obfuscation")
    
    let original = "secret_key_12345"
    print("Original string: \"\(original)\"")
    
    let obfuscated = StringObfuscator.obfuscate(original, key: 0x42)
    print("Obfuscated bytes: \(obfuscated)")
    
    let deobfuscated = StringObfuscator.deobfuscate(obfuscated, key: 0x42)
    print("Deobfuscated: \"\(deobfuscated)\"")
    
    print("\n✅ Match: \(original == deobfuscated)")
    
    print("\nCode to use in your app:")
    print("```swift")
    print("private let obfuscated: [UInt8] = \(obfuscated)")
    print("let key = StringObfuscator.deobfuscate(obfuscated, key: 0x42)")
    print("```")
}

func demoURLObfuscation() {
    printHeader("Demo 2: URL Obfuscation")
    
    let url = "https://api.example.com/validate"
    print("Original URL: \"\(url)\"")
    
    // Split URL into parts
    let parts = url.components(separatedBy: "://")
    let scheme = parts[0]
    let remaining = parts[1].components(separatedBy: "/")
    let domain = remaining[0]
    let path = "/" + remaining.dropFirst().joined(separator: "/")
    
    print("\nSplit into parts:")
    print("  Scheme: \"\(scheme)\"")
    print("  Domain: \"\(domain)\"")
    print("  Path: \"\(path)\"")
    
    let obfScheme = StringObfuscator.obfuscate(scheme)
    let obfDomain = StringObfuscator.obfuscate(domain)
    let obfPath = StringObfuscator.obfuscate(path)
    
    print("\nObfuscated parts:")
    print("  Scheme: \(obfScheme)")
    print("  Domain: \(obfDomain)")
    print("  Path: \(obfPath)")
    
    print("\nCode to use in your app:")
    print("```swift")
    print("private let scheme: [UInt8] = \(obfScheme)")
    print("private let domain: [UInt8] = \(obfDomain)")
    print("private let path: [UInt8] = \(obfPath)")
    print("")
    print("func getURL() -> String {")
    print("    let s = StringObfuscator.deobfuscate(scheme, key: 0x42)")
    print("    let d = StringObfuscator.deobfuscate(domain, key: 0x42)")
    print("    let p = StringObfuscator.deobfuscate(path, key: 0x42)")
    print("    return \"\\(s)://\\(d)\\(p)\"")
    print("}")
    print("```")
}

func demoCustomKey() {
    printHeader("Demo 3: Custom Obfuscation Key")
    
    let secret = "api_token_xyz"
    print("Original: \"\(secret)\"")
    
    // Use different keys
    let keys: [UInt8] = [0x42, 0x7F, 0xAA, 0xFF]
    
    print("\nObfuscated with different keys:")
    for key in keys {
        let obf = StringObfuscator.obfuscate(secret, key: key)
        print("  Key 0x\(String(key, radix: 16, uppercase: true)): \(obf)")
    }
    
    print("\n💡 Tip: Use different keys for different strings!")
}

func demoKeyGeneration() {
    printHeader("Demo 4: Dynamic Key Generation")
    
    print("Generate keys from app properties:")
    
    // Simulate bundle properties
    let bundleId = "com.example.app"
    let version = "1.0.0"
    
    func deriveKey(from components: [String]) -> UInt8 {
        let combined = components.joined()
        var hash: UInt8 = 0
        for byte in combined.utf8 {
            hash = hash &+ byte
        }
        return hash
    }
    
    let key = deriveKey(from: [bundleId, version])
    print("\nBundle ID: \(bundleId)")
    print("Version: \(version)")
    print("Derived Key: 0x\(String(key, radix: 16, uppercase: true))")
    
    let secret = "sensitive_data"
    let obf = StringObfuscator.obfuscate(secret, key: key)
    let decoded = StringObfuscator.deobfuscate(obf, key: key)
    
    print("\nOriginal: \"\(secret)\"")
    print("Obfuscated: \(obf)")
    print("Deobfuscated: \"\(decoded)\"")
    print("✅ Match: \(secret == decoded)")
    
    print("\n💡 Key changes if bundle ID or version changes!")
}

func demoInteractive() {
    printHeader("Demo 5: Interactive Obfuscator")
    
    print("Enter a string to obfuscate (or press Enter to skip):")
    
    guard let input = readLine(), !input.isEmpty else {
        print("Skipped.")
        return
    }
    
    print("\nChoose obfuscation key:")
    print("  1. Default (0x42)")
    print("  2. Strong (0x7F)")
    print("  3. Custom")
    print("Choice (1-3): ", terminator: "")
    
    let choice = readLine() ?? "1"
    var key: UInt8 = 0x42
    
    switch choice {
    case "2":
        key = 0x7F
    case "3":
        print("Enter hex key (e.g., FF): ", terminator: "")
        if let hex = readLine(), let value = UInt8(hex, radix: 16) {
            key = value
        }
    default:
        key = 0x42
    }
    
    let obfuscated = StringObfuscator.obfuscate(input, key: key)
    
    print("\n" + String(repeating: "-", count: 60))
    print("RESULTS")
    print(String(repeating: "-", count: 60))
    print("Original: \"\(input)\"")
    print("Key: 0x\(String(key, radix: 16, uppercase: true))")
    print("Obfuscated: \(obfuscated)")
    print("\nCopy this to your Swift code:")
    print("```swift")
    print("let obfuscated: [UInt8] = \(obfuscated)")
    print("let original = StringObfuscator.deobfuscate(obfuscated, key: 0x\(String(key, radix: 16, uppercase: true)))")
    print("```")
}

func demoVerification() {
    printHeader("Demo 6: Verification Tests")
    
    print("Running verification tests...\n")
    
    var passed = 0
    var failed = 0
    
    // Test 1: Basic obfuscation
    let test1 = "test"
    let obf1 = StringObfuscator.obfuscate(test1)
    let deobf1 = StringObfuscator.deobfuscate(obf1)
    if test1 == deobf1 {
        print("✅ Test 1: Basic obfuscation")
        passed += 1
    } else {
        print("❌ Test 1: Basic obfuscation FAILED")
        failed += 1
    }
    
    // Test 2: Empty string
    let test2 = ""
    let obf2 = StringObfuscator.obfuscate(test2)
    let deobf2 = StringObfuscator.deobfuscate(obf2)
    if test2 == deobf2 {
        print("✅ Test 2: Empty string")
        passed += 1
    } else {
        print("❌ Test 2: Empty string FAILED")
        failed += 1
    }
    
    // Test 3: Unicode
    let test3 = "Hello 世界 🌍"
    let obf3 = StringObfuscator.obfuscate(test3)
    let deobf3 = StringObfuscator.deobfuscate(obf3)
    if test3 == deobf3 {
        print("✅ Test 3: Unicode support")
        passed += 1
    } else {
        print("❌ Test 3: Unicode support FAILED")
        failed += 1
    }
    
    // Test 4: Multiple keys
    let test4 = "secret"
    for key: UInt8 in [0x42, 0x7F, 0xAA] {
        let obf = StringObfuscator.obfuscate(test4, key: key)
        let deobf = StringObfuscator.deobfuscate(obf, key: key)
        if test4 != deobf {
            print("❌ Test 4: Multiple keys FAILED (key: \(key))")
            failed += 1
            break
        }
    }
    if failed == 0 {
        print("✅ Test 4: Multiple keys")
        passed += 1
    }
    
    print("\n" + String(repeating: "-", count: 60))
    print("Results: \(passed) passed, \(failed) failed")
    print(String(repeating: "-", count: 60))
}

// MARK: - Main Menu

func showMenu() {
    print("\n" + String(repeating: "=", count: 60))
    print(" String Obfuscation Demo")
    print(" Modern Receipt Validation Test - Alfonso")
    print(String(repeating: "=", count: 60))
    print("\nChoose a demo:")
    print("  1. Basic String Obfuscation")
    print("  2. URL Obfuscation")
    print("  3. Custom Keys")
    print("  4. Dynamic Key Generation")
    print("  5. Interactive Obfuscator")
    print("  6. Verification Tests")
    print("  7. Run All Demos")
    print("  0. Exit")
    print("\nChoice: ", terminator: "")
}

func runDemo(_ choice: String) {
    switch choice {
    case "1":
        demoBasicObfuscation()
    case "2":
        demoURLObfuscation()
    case "3":
        demoCustomKey()
    case "4":
        demoKeyGeneration()
    case "5":
        demoInteractive()
    case "6":
        demoVerification()
    case "7":
        demoBasicObfuscation()
        demoURLObfuscation()
        demoCustomKey()
        demoKeyGeneration()
        demoVerification()
        print("\n✨ All demos completed!")
    default:
        print("Invalid choice")
    }
}

// MARK: - Entry Point

print("Loading...")

// Check if running with argument
if CommandLine.arguments.count > 1 {
    let arg = CommandLine.arguments[1]
    if arg == "--all" || arg == "-a" {
        runDemo("7")
        exit(0)
    } else if arg == "--help" || arg == "-h" {
        print("""
        Usage: swift ObfuscationDemo.swift [option]
        
        Options:
          --all, -a     Run all demos
          --help, -h    Show this help
          
        Or run without arguments for interactive menu.
        """)
        exit(0)
    }
}

// Interactive mode
while true {
    showMenu()
    
    guard let choice = readLine() else {
        break
    }
    
    if choice == "0" {
        print("\nGoodbye! 👋")
        break
    }
    
    runDemo(choice)
    
    print("\nPress Enter to continue...")
    _ = readLine()
}
