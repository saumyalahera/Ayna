//
//  ANCanvas.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//

import UIKit
import MetalKit

class ANCanvas: MTKView {
    
    var time:Float = 0
    
    //It will all th ebjects for rendering
    var shapes = [ANShape2D]()
    
    //MARK: - Color property
        ///Color KVO is used to clear color
        var color: UIColor? {
            didSet {
                guard let color = ANMetalHelper.colorToMTLClearColor(color: color) else {
                    return
                }
                self.clearColor = color
            }
        }
        
    //MARK: - Init Methods
        
        init(frame:CGRect) {
        
            //Init super
            super.init(frame: frame, device: ANMetalSingleton.device)
        
            //Set clear color
            self.color = UIColor.white
            
            //Delegate
            self.delegate = self
        }
        
        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

extension ANCanvas: MTKViewDelegate {
    
//MARK: - Metal View Delegate Functions
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
//Just use it for clearing color
    func draw(in view: MTKView) {
    
        guard let renderPassDescriptor = view.currentRenderPassDescriptor, let drawable = view.currentDrawable else {
            return
        }
        
        /*frameTimer += (1 / Float(view.preferredFramesPerSecond))/10
        print(frameTimer)*/
        
        //Command Buffer to process all the commands
        let commandBuffer = ANMetalSingleton.queue.makeCommandBuffer()
        
        //Commands converter
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        
        //time
        time += 1 / Float(view.preferredFramesPerSecond)
        
        //Render all lthe objects
        for shape in self.shapes {
            shape.render(renderCommandEncoder: commandEncoder!, time: time)
        }
        
        //Commit commands
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
