//
//  ANSingleton.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//

import MetalKit

/**
 This class is the most important class because it holds a  lot of me. This is a Metal tools class
 IT HOLDS ALL THE METAL INFO
 */
class ANMetalSingleton: NSObject {
    
    //MARK: - Create a shared device object
    static let shared = ANMetalSingleton()

    ///It is needed to create a metal device that will be used throughout the application
    public static var device:MTLDevice!
    
    ///Command Queue holds command buffers for rendering
    public static var queue:MTLCommandQueue!
    
    ///Render Command Pipeline
    public static var renderPipelineState:MTLRenderPipelineState!
    
    
    private override init() {}
    
//MARK: - It only creates device when it is called
    public static func setupMetalComponents(device: MTLDevice, queue: MTLCommandQueue) {
        /*Create device and queues*/
        self.device = device
        self.queue = queue
        /*I am doing this because for this engine, there will only be one pipeline state*/
        makeRenderPipeline()
    }

    public static func makeRenderPipeline() {
        guard let renderPipelineDescriptor = ANMetalHelper.createRenderPipelineDescriptor(device: device, vertexFunctionName: "vertexShader", fragmentFunctionName: "fragmentShader") else {
            print("Cannot init render pipeline")
            return
        }
        renderPipelineState = ANMetalHelper.createRenderPipeline(device: device!, renderPipelineDescriptor: renderPipelineDescriptor)
    }
}
