//
//  ANSquare2D.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/9/23.
//

import MetalKit

class ANSquare2D: ANShape2D {
    
    var name = "Square2D"
    
    init(vertices:[simd_float2]) {
        super.init()
        //convert
        self.vertices = vertices
        self.initialiseBuffers()
    }
    
}
