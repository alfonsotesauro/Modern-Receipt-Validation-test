//
//  ContentView.swift
//  Modern Receipt Test Alfonso
//
//  Created by Alfonso Tesauro
//

import SwiftUI

struct ContentView: View {
    @State private var validationResult = "Press 'Validate Receipt' to check"
    @State private var isValidating = false
    @State private var lastValidationDate: Date?
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Modern Receipt Validation")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            Text("with Code Obfuscation")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Validation Result Display
            VStack(alignment: .leading, spacing: 10) {
                Text("Validation Result:")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                ScrollView {
                    Text(validationResult)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
                .frame(height: 200)
            }
            .padding(.horizontal, 40)
            
            // Last validation timestamp
            if let date = lastValidationDate {
                Text("Last validated: \(date, style: .time)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Validate Button
            Button(action: validateReceipt) {
                HStack {
                    if isValidating {
                        ProgressView()
                            .scaleEffect(0.8)
                            .padding(.trailing, 5)
                    }
                    Text(isValidating ? "Validating..." : "Validate Receipt")
                        .fontWeight(.semibold)
                }
                .frame(width: 200)
                .padding(.vertical, 12)
                .background(isValidating ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .disabled(isValidating)
            
            // Info Section
            VStack(alignment: .leading, spacing: 8) {
                Text("About This App")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                InfoRow(title: "Purpose", value: "Demonstrate modern receipt validation")
                InfoRow(title: "Technique", value: "Local ASN.1 parsing with signature verification")
                InfoRow(title: "Obfuscation", value: "String XOR, method aliasing, control flow")
                InfoRow(title: "Security", value: "Anti-debug checks, runtime deobfuscation")
            }
            .padding(20)
            .background(Color.secondary.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal, 40)
            
            Spacer()
            
            // Footer
            Text("© 2024 Alfonso Tesauro")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .frame(minWidth: 600, minHeight: 700)
        .onAppear {
            // Perform initial validation on startup
            validateReceipt()
        }
    }
    
    // MARK: - Validation Logic
    
    private func validateReceipt() {
        isValidating = true
        
        // Perform validation on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let validator = ReceiptValidator()
            let result = validator.performValidation()
            
            // Update UI on main thread
            DispatchQueue.main.async {
                validationResult = result
                lastValidationDate = Date()
                isValidating = false
            }
        }
    }
}

// MARK: - Supporting Views

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title + ":")
                .fontWeight(.medium)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
        .font(.caption)
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}
