//
//  ClassificationModel.swift
//  iCoreML
//
//  Created by Jessy Viranaiken on 08/10/2024.
//

import CoreML
import Vision
import UIKit

class ClassificationModel {
  private var model: VNCoreMLModel?
  
  init() {
    guard let mlModel = try? MobileNetV2(configuration: MLModelConfiguration()).model else {
      print("Could not load model")
      return
    }
    
    model = try? VNCoreMLModel(for: mlModel)
    if model == nil {
      print("Could not create VNCoreMLModel")
    }
  }
  
  func classifyImage(image: UIImage, completion: @escaping (String?, Double?) -> Void) {
    guard let model = model, let ciImage = CIImage(image: image) else {
      completion(nil, nil)
      return
    }
    
    let request = VNCoreMLRequest(model: model) { request, error in
      guard let results = request.results as? [VNClassificationObservation],
            let firstResult = results.first else {
        completion(nil, nil)
        return
      }
      completion(firstResult.identifier, Double(firstResult.confidence))
    }
    
    let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
    do {
      try handler.perform([request])
    } catch {
      print("Error performing request: \(error)")
      completion(nil, nil)
    }
  }
}
