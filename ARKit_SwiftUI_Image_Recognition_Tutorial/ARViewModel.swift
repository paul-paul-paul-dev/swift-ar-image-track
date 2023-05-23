//
//  ARViewModel.swift
//  ARKit_SwiftUI_Image_Recognition_Tutorial
//
//  Created by Cole Dennis on 10/5/22.
//

import Foundation
import RealityKit
import ARKit
import SceneKit
import UIKit

class ARViewModel: UIViewController, ObservableObject, ARSessionDelegate {
    
    @Published private var model: ARModel = ARModel()
        
    let model_plane = ModelEntity(
        mesh: MeshResource.generateBox(width: 1, height: 1, depth: 0.005),
        materials: [SimpleMaterial(color: .white, isMetallic: true)]
    )
    
    let light = SpotLight()
    
    var anchorEntity = AnchorEntity()
    
    var arView : ARView {
        model.arView
    }
    
    var imageRecognizedVar : Bool {
        model.imageRecognizedVar
    }
    
    var recognizedImageName : String {
        model.recognizedImageName
    }
    
    func startSessionDelegate() {
        model.arView.session.delegate = self
    }
    
    func increaseLightIntensity() -> Void {
        light.light.intensity += 1000
    }
    
    func decreaseLightIntensity() -> Void {
        light.light.intensity -= 1000
    }
    
    func toggleLightSource(on: Bool) -> Void {
        light.light.intensity = on ? 4000 : 0
    }
    
    func initalize() {
        light.light.color = .white
        light.light.intensity = 0
        light.light.innerAngleInDegrees = 10.0
        light.light.outerAngleInDegrees = 15.0
        light.light.attenuationRadius = 0.5
        
        // Create a material with the texture
        var material = SimpleMaterial()
        material.color = .init(tint: .white.withAlphaComponent(0.999),
                               texture: .init(try! .load(named: "image1", in: nil)))
        material.metallic = 1
        material.roughness = 1
        model_plane.model?.materials = [material]
        
        self.anchorEntity.addChild(model_plane)
        self.anchorEntity.addChild(light)
        arView.scene.anchors.append(self.anchorEntity)
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Device Position
        let cameraTransform = Transform(matrix: frame.camera.transform)
        
        // Set Light Position to Device Position
        self.light.position = cameraTransform.translation
        self.light.orientation = cameraTransform.rotation
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        model.imageRecognized(anchors: anchors)
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        model.imageRecognized(anchors: anchors)
        
        guard let imageAnchor = anchors.first as? ARImageAnchor
        else { return }
        
        let multiplier = 1.1
        
        let width = Float(imageAnchor.referenceImage.physicalSize.height * multiplier)
        let height = Float(imageAnchor.referenceImage.physicalSize.width * multiplier)

        let anchorTransform = Transform(matrix: imageAnchor.transform)
        
        let anchorRotation = anchorTransform.rotation
        let rotation90Degrees = simd_quatf(angle: Float.pi/2, axis: SIMD3<Float>(1, 0, 0))
        let rotatedQuaternion = anchorRotation * rotation90Degrees
        
        // Set the positions and orientations of the model
        model_plane.scale = SIMD3<Float>(x: width, y: height, z: 0.005)
        self.model_plane.position = anchorTransform.translation
        self.model_plane.orientation = rotatedQuaternion
        
        self.anchorEntity = AnchorEntity(anchor: imageAnchor)
    }
}
