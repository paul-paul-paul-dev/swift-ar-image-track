//
//  ContentView.swift
//  ARKit_SwiftUI_Image_Recognition_Tutorial
//
//  Created by Cole Dennis on 10/5/22.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @ObservedObject var arViewModel : ARViewModel = ARViewModel()
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                VStack {
                    switch arViewModel.imageRecognizedVar {
                    case false: Text("No image").foregroundColor(.red)
                    case true: Text("Image found:").foregroundColor(.green)
                    }
                    if arViewModel.imageRecognizedVar {
                        Text(arViewModel.recognizedImageName)
                    }
                }
                .font(.callout)
                .background(RoundedRectangle(cornerRadius: 20).fill(.regularMaterial)).padding()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    var arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        arViewModel.startSessionDelegate()
        arViewModel.initalize()
        return arViewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif