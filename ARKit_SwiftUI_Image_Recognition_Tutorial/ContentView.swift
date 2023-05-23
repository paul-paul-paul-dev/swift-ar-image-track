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
    @State private var isOn = false
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    HStack {
                        Button(action: {
                            arViewModel.decreaseLightIntensity()
                        }) {
                            Image(systemName: "minus.circle")
                                .font(.system(size: 30))
                        }
                        .padding()
                        
                        Button(action: {
                            arViewModel.increaseLightIntensity()
                        }) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 30))
                        }
                        .padding()
                    }
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
                    .background(Rectangle().fill(.regularMaterial)).padding()
                    Button(action: {
                        isOn.toggle()
                        arViewModel.toggleLightSource(on: isOn)
                    }) {
                        
                        Image(systemName: isOn ? "power" : "poweroff")
                            .font(.system(size: 30))
                            .foregroundColor(isOn ? .green : .red)
                            .padding()
                       
                    }
                    .padding()
                }.frame(maxWidth: .infinity)
                    .frame(height: 50)
                
            }
                
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
