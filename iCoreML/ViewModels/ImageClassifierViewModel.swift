//
//  ImageClassifierViewModel.swift
//  iCoreML
//
//  Created by Jessy Viranaiken on 08/10/2024.
//

import SwiftUI

@Observable
class ImageClassifierViewModel {
  var image: UIImage?
  var classificationResult: String?
  var confidenceScore: Double?
  private var classificationModel = ClassificationModel()
  
  func classifyImage() {
    guard let image = image else { return }
    classificationModel.classifyImage(image: image) { [weak self] result, confidence in
      DispatchQueue.main.async {
        self?.classificationResult = result
        self?.confidenceScore = confidence
      }
    }
  }
}
