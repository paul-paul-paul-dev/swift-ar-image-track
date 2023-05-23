//
//  Quaternion+EulerAngles.swift
//  ARKit_SwiftUI_Image_Recognition_Tutorial
//
//  Created by Paul Dommer on 22.05.23.
//

import Foundation
import simd

extension SIMD3 where Scalar == Float {
    func rotated(by angles: SIMD3<Scalar>) -> SIMD3<Scalar> {
        let quaternion = simd_quatf(angle: angles[0], axis: SIMD3<Scalar>(1, 0, 0)) *
                         simd_quatf(angle: angles[1], axis: SIMD3<Scalar>(0, 1, 0)) *
                         simd_quatf(angle: angles[2], axis: SIMD3<Scalar>(0, 0, 1))
        
        let rotationMatrix = simd_float4x4(quaternion)
        let rotatedVector = rotationMatrix * SIMD4<Scalar>(x, y, z, 1.0)
        
        return SIMD3<Scalar>(rotatedVector.x, rotatedVector.y, rotatedVector.z)
    }
}

extension simd_float4x4 {
    var eulerAngles: simd_float3 {
        simd_float3(
            x: asin(-self[2][1]),
            y: atan2(self[2][0], self[2][2]),
            z: atan2(self[0][1], self[1][1])
        )
    }
}


func quatToEulerAngles(_ quat: simd_quatf) -> SIMD3<Float>{
    
    var angles = SIMD3<Float>();
    let qfloat = quat.vector
    
    // heading = x, attitude = y, bank = z
    
    let test = qfloat.x*qfloat.y + qfloat.z*qfloat.w;
    
    if (test > 0.499) { // singularity at north pole
        
        angles.x = 2 * atan2(qfloat.x,qfloat.w)
        angles.y = (.pi / 2)
        angles.z = 0
        return  angles
    }
    if (test < -0.499) { // singularity at south pole
        angles.x = -2 * atan2(qfloat.x,qfloat.w)
        angles.y = -(.pi / 2)
        angles.z = 0
        return angles
    }
    
    
    let sqx = qfloat.x*qfloat.x;
    let sqy = qfloat.y*qfloat.y;
    let sqz = qfloat.z*qfloat.z;
    angles.x = atan2(2*qfloat.y*qfloat.w-2*qfloat.x*qfloat.z , 1 - 2*sqy - 2*sqz)
    angles.y = asin(2*test)
    angles.z = atan2(2*qfloat.x*qfloat.w-2*qfloat.y*qfloat.z , 1 - 2*sqx - 2*sqz)
    
    return angles
}
