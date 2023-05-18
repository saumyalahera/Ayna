//
//  ANModels.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//

import Foundation
import simd

//MARK: - Structs
/**It is used to render color on shapes by passing vertex bytes**/
struct ANShapeColorConstant {
    var color:simd_float4
}

struct ANNodeUniform {
    var size: simd_float2 = .zero
    var backgroundColor: simd_float4 = .zero
    var radius: simd_float1 = .zero;
    var time:simd_float1 = .zero
}
