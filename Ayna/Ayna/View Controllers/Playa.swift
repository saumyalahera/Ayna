//
//  Playa.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//

import UIKit
import MetalKit


/**Create a Metal vView that will render different shaders**/
class Playa: UIViewController {

    ///This is where the main rendering is done
    var canvas:ANCanvas!
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Get command Queue and device because withput these objects, engine should not ignite
        guard let device = ANMetalHelper.createDevice(), let queue = ANMetalHelper.createCommandQueue(device: device) else {
            return
        }
        ANMetalSingleton.setupMetalComponents(device: device, queue: queue)
        
        self.setupCanvas()
    }
    
    func setupCanvas() {
        canvas = ANCanvas(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        canvas.color = UIColor.white
        self.view.addSubview(canvas)
        
        //Add Objects
        let triangle = ANTriangle2D(vertices: [simd_float2(0.0, 0.5), simd_float2(-0.5, -0.5), simd_float2(0.5, -0.5)])
        triangle.color = .yellow
        //canvas.shapes.append(triangle)
//
        let triangle2 = ANTriangle2D(vertices: [simd_float2(0.0, 0.0), simd_float2(-1.0, -1.0), simd_float2(1, -1)])
        triangle.color = .black
        //canvas.shapes.append(triangle2)
//
        let triangle3 = ANTriangle2D(vertices: [simd_float2(0.0, -0.5), simd_float2(-1.0, -1.0), simd_float2(1, -1)])
        triangle3.color = .black
        //canvas.shapes.append(triangle3)
        
        let square1 = ANSquare2D(vertices: [simd_float2(-1, 1), simd_float2(-1, -1), simd_float2(1,-1), simd_float2(1,1)])
        //let square1 = ANSquare2D(vertices: [simd_float2(-0.5, 0.5), simd_float2(-0.5, -0.5), simd_float2(0.5,-0.5), simd_float2(0.5,0.5)])
        square1.color = .black
        square1.uniform.size = simd_float2(Float(1), Float(1))//simd_float2(Float(self.view.frame.width), Float(self.view.frame.height))
        //simd_float2(Float(frame.size.width), Float(frame.size.height))
        
        canvas.shapes.append(square1)
    }
    
    
}
