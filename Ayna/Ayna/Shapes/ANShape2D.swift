//
//  ANShape2D.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//
import UIKit
import MetalKit

class ANShape2D: NSObject {

    ///It stores vertices values
    var vertices:[simd_float2]!
    
    ///This will hold important information about the shape.
    var vertexBuffer:MTLBuffer!
    
    //New
    let textureCoords: [Float] = [
        0, 0,
        0, 1,
        1, 1,
        1, 0,
    ]
    var indices:[UInt16] = [
        0,1,2,
        2,3,0
    ]
    var indexBuffer:MTLBuffer?
    var uniform = ANNodeUniform()
    var textureCoordsBuffer: MTLBuffer?
    ///This is the default color
    /*It will only be given to the shader*/
    private var shapeColorConstant = ANShapeColorConstant(color: simd_float4(1,1,1,1))
    
    ///Can change color with a simple UIColor instance
    var color:UIColor? {
        didSet {
            guard let color = ANMetalHelper.colorToSIMDComponents(color: color) else {
                return
            }
            self.shapeColorConstant.color = color
        }
    }
    
}

//MARK: - Buffers
/*Metal objects need a buffer to store its information like, vertices and other important information*/
extension ANShape2D {
    
    /*This is required for initalising subclasses, when you add an object on a paper object, you should init buffers and vertices.*/
    func initialiseBuffers(){
        guard let vertices = self.vertices else {
            return
        }
        //This is the main structure
        self.vertexBuffer = ANMetalSingleton.device.makeBuffer(bytes: vertices, length: MemoryLayout<simd_float2>.stride*vertices.count, options: [])
        
       
        
        //new
        uniform.size = simd_float2(Float(0), Float(0))
        uniform.backgroundColor = simd_float4(0, 1, 0, 1)
        uniform.radius = 50;
        self.textureCoordsBuffer = ANMetalSingleton.device.makeBuffer(bytes: textureCoords, length: MemoryLayout<Float>.stride * textureCoords.count, options: .storageModeShared)
        self.indexBuffer = ANMetalSingleton.device.makeBuffer(bytes: self.indices, length: self.indices.count*MemoryLayout<UInt16>.stride)
    }
    
}

//MARK: - Shape Render
/*Render the object*/
extension ANShape2D {
    

    func render(renderCommandEncoder:MTLRenderCommandEncoder, time: simd_float1) {
            
        uniform.time = time
        
        renderCommandEncoder.setVertexBuffer(self.vertexBuffer, offset: 0, index: 0)
            
        //check if color is set then the renderpipeline changes
        renderCommandEncoder.setRenderPipelineState(ANMetalSingleton.renderPipelineState)
            
        //Add a render command encoder
        renderCommandEncoder.setVertexBytes(&self.shapeColorConstant, length: MemoryLayout<ANShapeColorConstant>.stride, index: 1)
        
        //new
        renderCommandEncoder.setVertexBuffer(textureCoordsBuffer, offset: 0, index: 2)
        renderCommandEncoder.setFragmentBytes(&uniform, length: MemoryLayout<ANNodeUniform>.stride, index: 0)
            
        //new
        //Render the shape
        //renderCommandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.vertices.count)
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.indices.count, indexType: .uint16, indexBuffer: self.indexBuffer!, indexBufferOffset: 0)
    }
    
}
