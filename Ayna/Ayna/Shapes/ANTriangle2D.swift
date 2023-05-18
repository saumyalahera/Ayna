//
//  ANTriangle2D.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//
import MetalKit

class ANTriangle2D: ANShape2D {
    
    var name = "Triangle2D"
    
    init(vertices:[simd_float2]) {
        super.init()
        //convert
        self.vertices = vertices
        self.initialiseBuffers()
    }
}
