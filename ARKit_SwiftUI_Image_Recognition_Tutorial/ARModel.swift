//
//  ARModel.swift
//  ARKit_SwiftUI_Image_Recognition_Tutorial
//
//  Created by Cole Dennis on 10/5/22.
//

import Foundation
import RealityKit
import ARKit

struct ARModel {
    private(set) var arView : ARView
    
    var imageRecognizedVar = false
    var recognizedImageName : String = ""

    init() {
        arView = ARView(frame: .zero)
        
        arView.automaticallyConfigureSession = false
        
        
        guard let trackerImage = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = trackerImage
        configuration.maximumNumberOfTrackedImages = 1

        arView.renderOptions = [.disableCameraGrain, .disableHDR, .disableMotionBlur, .disableDepthOfField, .disableFaceMesh, .disablePersonOcclusion, .disableGroundingShadows, .disableAREnvironmentLighting]
        
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }

    mutating func imageRecognized(anchors: [ARAnchor]) {
        
        guard ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) != nil else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        for anchor in anchors {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            recognizedImageName = imageAnchor.referenceImage.name ?? ""
            imageRecognizedVar = true
        }
    }
}
