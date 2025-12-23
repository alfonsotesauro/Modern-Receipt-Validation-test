//
//  ReceiptValidator.swift
//  Modern Receipt Test Alfonso
//
//  Created by Alfonso Tesauro
//

import Foundation
import Security

/// Receipt validation result
enum ReceiptValidationResult {
    case valid(bundleId: String, version: String)
    case invalid(reason: String)
    case notFound
    case error(String)
}

/// Modern receipt validator with obfuscation
/// Validates App Store receipts using ASN.1 parsing and cryptographic verification
class ReceiptValidator: ObfuscatedOperations {
    
    // MARK: - Obfuscated String Constants
    
    // These strings are obfuscated using XOR with key 0x42
    // Actual values are decoded at runtime to avoid hardcoding in binary
    
    // "receipt" - XOR(0x42) -> obfuscated
    private static let obfuscatedReceiptPath: [UInt8] = [0x30, 0x27, 0x25, 0x27, 0x29, 0x32, 0x34]
    
    // "Contents/_MASReceipt/receipt" - XOR(0x42) -> obfuscated 
    private static let obfuscatedMASPath: [UInt8] = [
        0x01, 0x2f, 0x2e, 0x34, 0x27, 0x2e, 0x34, 0x31, 0x61,
        0x5d, 0x0d, 0x03, 0x11, 0x30, 0x27, 0x25, 0x27, 0x29,
        0x32, 0x34, 0x61, 0x30, 0x27, 0x25, 0x27, 0x29, 0x32, 0x34
    ]
    
    // Bundle identifier obfuscation key
    private static let bundleKey: UInt8 = 0x42
    
    // MARK: - ObfuscatedOperations Protocol (Aliased Methods)
    
    /// Obfuscated method: checks if receipt exists
    func a1b2c3() -> Bool {
        return ControlFlowObfuscator.obfuscatedCheck(self) { _ in
            return self.receiptExists()
        }
    }
    
    /// Obfuscated method: gets receipt data
    func x7y8z9() -> Data? {
        return ControlFlowObfuscator.delayedOperation {
            return self.loadReceiptData()
        }
    }
    
    /// Obfuscated method: gets bundle identifier
    func m4n5o6() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    // MARK: - Public API
    
    /// Validates the app receipt
    func validateReceipt() -> ReceiptValidationResult {
        // Anti-debug check
        if AntiDebug.isDebuggerAttached() || AntiDebug.hasDebugEnvironment() {
            // In production, might want to handle this differently
            // For now, we'll continue but log it
            print("⚠️ Debug environment detected")
        }
        
        // Check if receipt exists using obfuscated method
        guard a1b2c3() else {
            return .notFound
        }
        
        // Load receipt data using obfuscated method
        guard let receiptData = x7y8z9() else {
            return .error("Failed to load receipt data")
        }
        
        // Parse the receipt
        guard let receiptInfo = parseReceipt(receiptData) else {
            return .invalid(reason: "Failed to parse receipt")
        }
        
        // Verify signature
        guard verifyReceiptSignature(receiptData) else {
            return .invalid(reason: "Invalid signature")
        }
        
        // Verify bundle identifier using obfuscated method
        let currentBundleId = m4n5o6()
        guard receiptInfo.bundleId == currentBundleId else {
            return .invalid(reason: "Bundle ID mismatch")
        }
        
        // Additional checks can be added here (expiration, etc.)
        
        return .valid(bundleId: receiptInfo.bundleId, version: receiptInfo.appVersion)
    }
    
    // MARK: - Private Methods
    
    /// Checks if receipt exists in bundle
    private func receiptExists() -> Bool {
        let receiptURL = getReceiptURL()
        return FileManager.default.fileExists(atPath: receiptURL.path)
    }
    
    /// Loads receipt data from bundle
    private func loadReceiptData() -> Data? {
        let receiptURL = getReceiptURL()
        return try? Data(contentsOf: receiptURL)
    }
    
    /// Gets the receipt URL (obfuscated path building)
    private func getReceiptURL() -> URL {
        let bundle = Bundle.main
        
        // Build path using obfuscated strings
        let receiptName = StringObfuscator.deobfuscate(Self.obfuscatedReceiptPath, key: Self.bundleKey)
        let masPath = StringObfuscator.deobfuscate(Self.obfuscatedMASPath, key: Self.bundleKey)
        
        // Try standard receipt location first
        if let receiptURL = bundle.appStoreReceiptURL {
            return receiptURL
        }
        
        // Fallback to manual path construction
        let bundleURL = bundle.bundleURL
        return bundleURL.appendingPathComponent(masPath)
    }
    
    // MARK: - Receipt Parsing (ASN.1)
    
    /// Receipt information extracted from ASN.1
    private struct ReceiptInfo {
        let bundleId: String
        let appVersion: String
        let originalAppVersion: String?
    }
    
    /// Parses receipt data using ASN.1 format
    private func parseReceipt(_ data: Data) -> ReceiptInfo? {
        // This is a simplified ASN.1 parser
        // Production apps should use a more robust ASN.1 library
        
        var bundleId = ""
        var appVersion = ""
        var originalVersion: String?
        
        // ASN.1 attribute types (as per Apple's specification)
        let bundleIdType = 2
        let appVersionType = 3
        let originalAppVersionType = 19
        
        // Parse the PKCS7 container
        guard let attributes = extractPKCS7Attributes(from: data) else {
            return nil
        }
        
        // Extract relevant attributes
        for attribute in attributes {
            switch attribute.type {
            case bundleIdType:
                bundleId = attribute.value
            case appVersionType:
                appVersion = attribute.value
            case originalAppVersionType:
                originalVersion = attribute.value
            default:
                break
            }
        }
        
        guard !bundleId.isEmpty && !appVersion.isEmpty else {
            return nil
        }
        
        return ReceiptInfo(
            bundleId: bundleId,
            appVersion: appVersion,
            originalAppVersion: originalVersion
        )
    }
    
    /// ASN.1 Attribute
    private struct ASN1Attribute {
        let type: Int
        let value: String
    }
    
    /// Extracts PKCS7 attributes from receipt data
    /// This is a simplified implementation for demonstration
    private func extractPKCS7Attributes(from data: Data) -> [ASN1Attribute]? {
        // In a production app, you would use a proper ASN.1 parser
        // This is a simplified version that extracts basic structure
        
        var attributes: [ASN1Attribute] = []
        
        // For demonstration, we'll check if the data looks like a valid receipt
        // Real implementation would parse the full ASN.1/DER structure
        
        // Check for PKCS7 signature (starts with 0x30)
        guard data.count > 4 && data[0] == 0x30 else {
            return nil
        }
        
        // In a real implementation, you would:
        // 1. Parse the PKCS7 container
        // 2. Extract the signed data
        // 3. Parse the receipt attributes
        // 4. Verify each attribute's structure
        
        // For this demo, we'll create sample attributes
        // In production, parse actual ASN.1 structure
        
        if let bundleId = Bundle.main.bundleIdentifier {
            attributes.append(ASN1Attribute(type: 2, value: bundleId))
        }
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
            attributes.append(ASN1Attribute(type: 3, value: version))
        }
        
        return attributes
    }
    
    // MARK: - Signature Verification
    
    /// Verifies receipt signature against Apple's root certificate
    private func verifyReceiptSignature(_ receiptData: Data) -> Bool {
        // This is a simplified signature verification
        // Production apps should verify against Apple's actual root certificate
        
        // Check if data is in PKCS7 format
        guard receiptData.count > 0 && receiptData[0] == 0x30 else {
            return false
        }
        
        // In production, you would:
        // 1. Load Apple's root certificate
        // 2. Extract the signature from PKCS7 container
        // 3. Verify signature using SecKey APIs
        // 4. Check certificate chain validity
        // 5. Verify signing time is valid
        
        // For this demonstration, we perform basic checks
        
        // Get Apple root certificate (in production, embed this in app)
        guard let appleRootCert = getAppleRootCertificate() else {
            return false
        }
        
        // Verify using Security framework
        return verifyPKCS7Signature(receiptData, certificate: appleRootCert)
    }
    
    /// Gets Apple's root certificate for verification
    /// In production, embed the actual certificate in the app
    /// TODO: For production, embed Apple's actual root certificate DER data
    private func getAppleRootCertificate() -> SecCertificate? {
        // Apple Inc. Root Certificate
        // In a production app, embed the actual DER-encoded certificate
        // This is a placeholder for the demo - returns nil to demonstrate structure
        
        // The real certificate can be obtained from:
        // https://www.apple.com/certificateauthority/
        
        // Production implementation would:
        // 1. Embed certificate as Data in app bundle or as obfuscated bytes
        // 2. let certData = Data([/* DER encoded certificate bytes */])
        // 3. return SecCertificateCreateWithData(nil, certData as CFData)
        
        // For this demo, we'll return nil and skip actual verification
        // In production, decode the embedded certificate data
        return nil
    }
    
    /// Verifies PKCS7 signature
    private func verifyPKCS7Signature(_ data: Data, certificate: SecCertificate) -> Bool {
        // This would use Security framework to verify the signature
        // Implementation would involve:
        // 1. Creating a SecPolicy for code signing
        // 2. Creating a SecTrust object
        // 3. Evaluating the trust
        
        // Simplified for demo - in production use actual SecTrust evaluation
        
        var trust: SecTrust?
        let policy = SecPolicyCreateBasicX509()
        
        let status = SecTrustCreateWithCertificates(
            certificate,
            policy,
            &trust
        )
        
        guard status == errSecSuccess, let trust = trust else {
            return false
        }
        
        // Evaluate trust (requires iOS 12.0+, macOS 10.14+)
        var error: CFError?
        let isValid = SecTrustEvaluateWithError(trust, &error)
        
        return isValid
    }
    
    // MARK: - Obfuscated Validation Entry Point
    
    /// Public method with obfuscated implementation
    func performValidation() -> String {
        let result = validateReceipt()
        
        switch result {
        case .valid(let bundleId, let version):
            return "✅ Valid Receipt\nBundle ID: \(bundleId)\nVersion: \(version)"
        case .invalid(let reason):
            return "❌ Invalid Receipt\nReason: \(reason)"
        case .notFound:
            return "⚠️ Receipt Not Found\nThis app may be running in development mode or outside the App Store."
        case .error(let message):
            return "⚠️ Validation Error\n\(message)"
        }
    }
}

// MARK: - Helper Extensions

extension Data {
    /// Converts data to hex string for debugging
    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }
}

/*
 RECEIPT VALIDATION NOTES:
 
 This implementation demonstrates the structure of receipt validation with obfuscation.
 For production use, consider:
 
 1. Use a production-ready ASN.1 parser (e.g., SwiftASN1 or OpenSSL)
 2. Embed Apple's actual root certificate in your app
 3. Implement full PKCS7 signature verification
 4. Add receipt refresh logic if receipt is missing
 5. Validate receipt expiration for subscriptions
 6. Check receipt hash matches device identifiers
 7. Implement network-based validation as a fallback
 8. Add more sophisticated obfuscation
 9. Use string encryption for sensitive data
 10. Implement certificate pinning for API calls
 
 SECURITY CONSIDERATIONS:
 
 - Never store validation results in persistent storage
 - Perform validation checks at multiple points in app lifecycle
 - Combine local and server-side validation
 - Use code obfuscation tools at compile time
 - Implement jailbreak detection
 - Add runtime integrity checks
 - Obfuscate all security-related strings and constants
 - Use multiple layers of validation
 - Fail securely if validation cannot be completed
 */
