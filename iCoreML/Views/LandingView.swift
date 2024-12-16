//
//  LandingView.swift
//  iCoreML
//
//  Created by Jessy Viranaiken on 08/10/2024.
//

import SwiftUI
import PhotosUI

struct LandingView: View {
  
  @State private var viewModel = ImageClassifierViewModel()
  @State private var showingImagePicker = false
  
  var body: some View {
    VStack {
      Text("iCoreML")
        .font(.largeTitle)
        .padding()
      
      if let image = viewModel.image {
        Image(uiImage: image)
          .resizable()
          .scaledToFit()
          .frame(width: 300, height: 300)
          .cornerRadius(10)
          .shadow(radius: 10)
      } else {
        Text("Aucune image sélectionnée.")
          .foregroundColor(.gray)
      }
      
      Button("Sélectionner une image") {
        showingImagePicker = true
      }
      .padding()
      .sheet(isPresented: $showingImagePicker) {
        ImagePicker(image: self.$viewModel.image) { selectedImage in
          viewModel.image = selectedImage
          viewModel.classifyImage()
        }
      }
      
      if let classificationResult = viewModel.classificationResult,
         let confidenceScore = viewModel.confidenceScore {
        VStack{
          Text("Résultat de la classification :")
            .font(.title3)
            .bold()
          Divider()
          VStack(alignment: .leading){
            Text("Classe : \(classificationResult)")
            Text("Confiance : \(String(format: "%.2f", confidenceScore * 100))%")
          }
          .padding(.horizontal)
        }
        .padding(.vertical)
        .frame(width: 325)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
    }
    .padding()
  }
}
