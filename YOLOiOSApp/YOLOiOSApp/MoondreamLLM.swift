//
//  MoondreamLLM.swift
//  UltralyticsYOLO
//
//  Created by Anay Agrawal on 7/29/26.
//

import Foundation
import UIKit

struct MoondreamLLM {
    private var apiKey: String {
        get {
            guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
                fatalError("Couldn't find file 'Secrets.plist'.")
            }
            
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "API_KEY") as? String else {
                fatalError("Couldn't find key 'API_KEY' in 'Secrets.plist'.")
            }
            return value
        }
    }
    
    func queryLLM(image: UIImage, prompt: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            throw NSError(domain: "MoondreamError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode image"])
        }
        
        guard let url = URL(string: "https://api.moondream.ai/v1/query") else {
            throw NSError(domain: "MoondreamError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to create API POST request URL"])
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "moondream3.1-9B-A2B",
            "image_url": "data:image/jpeg;base64,\(imageData)",
            "question": prompt
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "MoondreamError", code: -3, userInfo: [NSLocalizedDescriptionKey: "API request failed"])
        }
        
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
            let answer = json["answer"] as? String {
                return answer
            }
        
        throw NSError(domain: "MoondreamError", code: -4, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"])
    }
}
