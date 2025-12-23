//
//  ObfuscationHelpers.swift
//  Modern Receipt Test Alfonso
//
//  Created by Alfonso Tesauro
//

import Foundation
import CommonCrypto

/// Obfuscation utilities to protect sensitive strings and logic from reverse engineering
/// This demonstrates various obfuscation techniques that can be extended for production use

// MARK: - String Obfuscation

/// Simple XOR-based string obfuscation
/// Usage: Store obfuscated strings in code, decode at runtime
struct StringObfuscator {
    
    /// Obfuscates a string using XOR encryption with a key
    static func obfuscate(_ string: String, key: UInt8 = 0x42) -> [UInt8] {
        return string.utf8.map { $0 ^ key }
    }
    
    /// Deobfuscates a byte array back to string
    static func deobfuscate(_ bytes: [UInt8], key: UInt8 = 0x42) -> String {
        let decodedBytes = bytes.map { $0 ^ key }
        return String(bytes: decodedBytes, encoding: .utf8) ?? ""
    }
}

// MARK: - Method Name Aliasing

/// Protocol to hide actual method names from reverse engineering
/// Extend this pattern to obfuscate critical APIs
protocol ObfuscatedOperations {
    // Alias names that don't reveal their purpose
    func a1b2c3() -> Bool
    func x7y8z9() -> Data?
    func m4n5o6() -> String
}

// MARK: - Dynamic String Building

/// Builds strings dynamically at runtime to avoid hardcoded strings in binary
struct DynamicStringBuilder {
    
    /// Builds a string from character codes to hide the actual string
    static func buildFromCodes(_ codes: [UInt8]) -> String {
        return String(bytes: codes, encoding: .utf8) ?? ""
    }
    
    /// Splits and reassembles strings to obfuscate
    static func assembleString(parts: [String], separator: String = "") -> String {
        return parts.joined(separator: separator)
    }
    
    /// Reverse string and unreverse at runtime
    static func reverseObfuscate(_ reversed: String) -> String {
        return String(reversed.reversed())
    }
}

// MARK: - Control Flow Obfuscation

/// Adds junk operations and control flow complexity
struct ControlFlowObfuscator {
    
    /// Adds dummy calculations to obfuscate actual logic
    static func obfuscatedCheck<T>(_ value: T, transform: (T) -> Bool) -> Bool {
        // Add junk operations
        let _ = arc4random() % 1000
        let _ = Date().timeIntervalSince1970
        
        // Actual check
        let result = transform(value)
        
        // More junk
        let _ = UUID().uuidString
        
        return result
    }
    
    /// Performs operation with random delays to confuse timing analysis
    static func delayedOperation<T>(_ operation: () -> T) -> T {
        let delay = Double.random(in: 0.001...0.01)
        Thread.sleep(forTimeInterval: delay)
        return operation()
    }
}

// MARK: - Data Obfuscation

/// Obfuscates binary data
struct DataObfuscator {
    
    /// XOR obfuscation for Data objects
    static func obfuscate(_ data: Data, key: UInt8 = 0x7F) -> Data {
        return Data(data.map { $0 ^ key })
    }
    
    /// Deobfuscate Data
    static func deobfuscate(_ data: Data, key: UInt8 = 0x7F) -> Data {
        return Data(data.map { $0 ^ key })
    }
    
    /// Adds random padding to obscure data size
    static func addPadding(_ data: Data) -> Data {
        var padded = data
        let paddingSize = Int.random(in: 10...50)
        let padding = Data((0..<paddingSize).map { _ in UInt8.random(in: 0...255) })
        padded.append(padding)
        return padded
    }
}

// MARK: - Hash-based Key Derivation

/// Derives obfuscation keys from multiple sources
struct KeyDerivation {
    
    /// Derives a key from multiple string components
    static func deriveKey(from components: [String]) -> UInt8 {
        let combined = components.joined()
        var hash: UInt8 = 0
        for byte in combined.utf8 {
            hash = hash &+ byte
        }
        return hash
    }
    
    /// Creates a pseudo-random key based on bundle properties
    static func bundleBasedKey() -> UInt8 {
        let bundleId = Bundle.main.bundleIdentifier ?? "default"
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        return deriveKey(from: [bundleId, version])
    }
}

// MARK: - Anti-Debug Checks

/// Basic anti-debugging techniques
struct AntiDebug {
    
    /// Checks if debugger is attached (basic check)
    static func isDebuggerAttached() -> Bool {
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        
        let result = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
        
        if result != 0 {
            return false
        }
        
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }
    
    /// Checks for common debugging environment variables
    static func hasDebugEnvironment() -> Bool {
        let debugVars = ["DYLD_INSERT_LIBRARIES", "MallocStackLogging"]
        for variable in debugVars {
            if getenv(variable) != nil {
                return true
            }
        }
        return false
    }
}

// MARK: - Example Usage and Extension Guide

/*
 HOW TO EXTEND OBFUSCATION:
 
 1. String Obfuscation:
    - Instead of: let key = "MySecretKey"
    - Use: let obfuscatedKey: [UInt8] = [83, 121, 65, 101, 99, 114, 101, 116, 75, 101, 121] (XOR 0x42)
           let key = StringObfuscator.deobfuscate(obfuscatedKey)
 
 2. Method Aliasing:
    - Implement ObfuscatedOperations protocol
    - Use cryptic method names
    - Add wrapper methods with descriptive internal names
 
 3. Dynamic String Building:
    - Build strings from character codes at runtime
    - Split strings and reassemble them
    - Use reverse strings and unreverse at runtime
 
 4. Control Flow:
    - Add dummy operations between critical checks
    - Use nested conditions with junk code
    - Randomize execution timing
 
 5. Data Protection:
    - XOR all sensitive binary data
    - Add random padding to obscure sizes
    - Derive keys from app bundle properties
 
 6. Anti-Debugging:
    - Check for debugger attachment before sensitive operations
    - Verify environment isn't compromised
    - Exit gracefully if debugging detected
 
 PRODUCTION RECOMMENDATIONS:
 - Use multi-layer obfuscation (combine multiple techniques)
 - Rotate keys and obfuscation patterns regularly
 - Add code that modifies itself at runtime
 - Use LLVM obfuscation passes during compilation
 - Consider commercial obfuscation tools for critical apps
 - Implement integrity checks on code sections
 - Use certificate pinning for network operations
 - Store sensitive data in Keychain, not in code
 */
