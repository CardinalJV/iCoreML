//
//  ImagePicker.swift
//  iCoreML
//
//  Created by Jessy Viranaiken on 08/10/2024.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  var completionHandler: (UIImage) -> Void
  
  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    @Binding var image: UIImage?
    var completionHandler: (UIImage) -> Void
    
    init(image: Binding<UIImage?>, completionHandler: @escaping (UIImage) -> Void) {
      _image = image
      self.completionHandler = completionHandler
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)
      guard let result = results.first else { return }
      
        // Assurez-vous que le résultat est une image
      if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
        result.itemProvider.loadObject(ofClass: UIImage.self) { [self] object, error in
          if let image = object as? UIImage {
            DispatchQueue.main.async {
              self.image = image
              self.completionHandler(image)
            }
          }
        }
      }
    }
  }
  
  func makeCoordinator() -> Coordinator {
    return Coordinator(image: $image, completionHandler: completionHandler)
  }
  
  func makeUIViewController(context: Context) -> PHPickerViewController {
    var configuration = PHPickerConfiguration()
    configuration.selectionLimit = 1
    configuration.filter = .images
    
    let picker = PHPickerViewController(configuration: configuration)
    picker.delegate = context.coordinator
    return picker
  }
  
  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
