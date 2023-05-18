//
//  MetalHelper.swift
//  Ayna
//
//  Created by Saumya Lahera on 5/8/23.
//
import UIKit
import MetalKit

class ANMetalHelper: NSObject {
    
}

//MARK: - Render Pipeline Descriptor
/**This extension helps create a render pipeline descriptor needed for render pipeline state*/
extension ANMetalHelper {
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - pixelFormat:      Frame buffer pixel format
            - vertexFunction:   It attaches vertex buffer required for Pipeline state
            - fragmentFunction: It attaches fragment buffer required for Pipeline state
        - Returns: A render pipeline descriptor*/
    class func createRenderPipelineDescriptor(pixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm, vertexFunction:MTLFunction?, fragmentFunction:MTLFunction?) -> MTLRenderPipelineDescriptor?{
        
        //Create render pipeline descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        //Set frame buffer pixel format
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        //Set vertex function
        renderPipelineDescriptor.vertexFunction = vertexFunction
        
        //Set fragment function
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        //Return render pipeline descriptor
        return renderPipelineDescriptor
    }
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - pixelFormat:      Frame buffer pixel format
            - vertexFunctionName:   It attaches vertex buffer required for Pipeline state
            - fragmentFunctionName: It attaches fragment buffer required for Pipeline state
        - Returns: A render pipeline descriptor*/
    class func createRenderPipelineDescriptor(device: MTLDevice?, pixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm, vertexFunctionName:String, fragmentFunctionName:String) -> MTLRenderPipelineDescriptor?{
        
        //Create render pipeline descriptor
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        //Set frame buffer pixel format
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        //Get vertex function
        let vertexFunction = ANMetalHelper.getMetalFunction(device: device, name: vertexFunctionName)
        
        //Get Fragment function
        let fragmentFunction = ANMetalHelper.getMetalFunction(device: device, name: fragmentFunctionName)
        
        //Set vertex function
        renderPipelineDescriptor.vertexFunction = vertexFunction
        
        //Set fragment function
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        //Return render pipeline descriptor
        return renderPipelineDescriptor
    }
}

//MARK: - Render Pipeline
/**This extension helps create a render pipeline state*/
extension ANMetalHelper {
    
    /**This function creates a Render Pipeline Descriptor
        - Parameters:
            - device: It is needed to make a render pipeline state
            - renderPipelineDescriptor: This is needed to create a render pipeline
                
        - Returns: A render pipeline*/
        class func createRenderPipeline(device: MTLDevice?, renderPipelineDescriptor: MTLRenderPipelineDescriptor) -> MTLRenderPipelineState? {
        
        //Render pipeline state
        var renderPipelineState:MTLRenderPipelineState?
        
        //Create render pipeline state
        do {
            renderPipelineState = try device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        }catch let error as NSError {
            print("Could not create render pipeline: \(error.localizedDescription)")
            
        }
        
        //Return render pipeline state
        return renderPipelineState
        
    }
    
}

//MARK: - Metal Buffer Functions
/**This extension is to work with metal buffer object*/
extension ANMetalHelper {
    
    /**This method will make the use of a simple. It is independent of the class
        - Parameters:
            - device: Metal device for creating a metal buffer
            - rawData: It is unformatted data
            - length: Raw data length
            - options: Resource storage modes allow you to define the storage location and access permissions for your MTLBuffer and MTLTexture objects.*/
    class func createBuffer(device: MTLDevice?, rawData: UnsafeRawPointer, length: Int, options: MTLResourceOptions) -> MTLBuffer?{
        
        //Return a simple function
        return device?.makeBuffer(bytes: rawData, length: length, options: options)
    }
    
}

//MARK: - Metal Library Functions
/**This extension has shader library functions required to attach to a render pipeline*/
extension ANMetalHelper {
    
    /**It returns a MTLFunction from a shader file. This function is indepedent of the metal device object in the class
        - Parameters:
            - device: MTLDevice object needed to create Metal Library
            - name:   It is the name of the function to fetch from a Metal file
        - Returns:    It returns the metal function of the name*/
    class func getMetalFunction(device: MTLDevice?, name: String) -> MTLFunction? {
        guard let defaultLibrary = device?.makeDefaultLibrary() else {
            return nil
        }
        return defaultLibrary.makeFunction(name: name)
    }
    
    /**It returns a MTLFunction from a shader file. This function is indepedent of the metal device object in the class. It doesnt need other objects, but the function name
        - Parameters:
            - name:   It is the name of the function to fetch from a Metal file
        - Returns:    It returns the metal function of the name*/
    class func getMetalFunction(name: String) -> MTLFunction? {
        
        //Create a metal device
        let device = MTLCreateSystemDefaultDevice()
        
        //Create a default library for getting functions
        let defaultLibrary = device?.makeDefaultLibrary()
        
        //Return a function
        return defaultLibrary?.makeFunction(name: name)
    }
}

//MARK: - Metal Color Functions
/**This extension has metal color functions*/
extension ANMetalHelper {
    
    /**This function comverts UIColor to MTLClearColor
        - Parameters:
            - color - This is a UIColor that is supposed to be converted
        - Returns: MTLClearColor that is equivalent UIColor values or nil */
    class func colorToMTLClearColor(color:UIColor?) -> MTLClearColor? {
        
        //Get color components
        guard let components = color?.cgColor.components else {
            return nil
        }
        /*This happens with colors like black and white where there are only two inputs. rgb have same value and alpha.*/
        if(components.count < 4) {
            return MTLClearColor(red: Double(components[0]), green: Double(components[0]), blue: Double(components[0]), alpha: Double(components[1]))
        }
        //Map them to the right components
        return MTLClearColor(red: Double(components[0]), green: Double(components[1]), blue: Double(components[2]), alpha: Double(components[3]))
    }
    
    /**This function comverts UIColor to MTLClearColor simd_float4 components
        - Parameters:
            - color - This is a UIColor that is supposed to be converted
        - Returns: simd_float4 that is equivalent UIColor values or nil */
    class func colorToSIMDComponents(color:UIColor?) -> simd_float4? {
        
        //Get color components
        guard let components = color?.cgColor.components else {
            return nil
        }
        /*This happens with colors like black and white where there are only two inputs. rgb have same value and alpha.*/
        if(components.count < 4) {
            return simd_float4(Float(components[0]), Float(components[0]), Float(components[0]), Float(components[1]))
        }else {
            return simd_float4(Float(components[0]), Float(components[1]), Float(components[2]), Float(components[3]))
        }
    }
}
//MARK: - Metal Device Functions
/**This extension is to work with metal device object*/
extension ANMetalHelper {
    /**Get a GPU instance. It is a class method and do not need to create
        - Returns: Metal Device*/
    class func createDevice() -> MTLDevice?{
        //Returns a device
        return MTLCreateSystemDefaultDevice()
    }
}

//MARK: - Metal Command Queue Functions
/**This extension is to work with Metal Command Queue*/
extension ANMetalHelper {
    /**Creates command Queue and returns one
        - Returns: Metal Command Queue*/
    class func createCommandQueue(device: MTLDevice?) -> MTLCommandQueue?{
        //Returns a queue
        return device?.makeCommandQueue()
    }
}

//MARK: - Autolayout Methods
/**This class is to add Autolayout constraints**/
extension ANMetalHelper {
    
/**This is used to make **/
   class func addConstraints(leading:CGFloat, trailing:CGFloat, top:CGFloat, bottom:CGFloat, view:UIView) {
        guard let superview = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
            view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
            view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
        ])
        
    }
    
    class func addConstraints(leading:CGFloat, trailing:CGFloat, bottom:CGFloat, height:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.heightAnchor.constraint(equalToConstant: height),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(leading:CGFloat, top:CGFloat, bottom:CGFloat, widthMultiplier: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: widthMultiplier),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(trailing:CGFloat, top:CGFloat, bottom:CGFloat, widthMultiplier: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: widthMultiplier),
             view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom)
         ])
     }
    
    class func addConstraints(leading:CGFloat, trailing:CGFloat, top:CGFloat, height: CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
             view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing),
             view.topAnchor.constraint(equalTo: superview.topAnchor, constant: top),
             view.heightAnchor.constraint(equalToConstant: height),
             view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading)
         ])
     }
    
    class func addConstraints(height:CGFloat, width:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.widthAnchor.constraint(equalToConstant: width),
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
         ])
     }
    
    class func addConstraints(leading: CGFloat, trailing: CGFloat, height:CGFloat, view:UIView) {
         guard let superview = view.superview else {
             return
         }
         view.translatesAutoresizingMaskIntoConstraints = false
         
         NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: height),
            view.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading),
            view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing)
         ])
     }
}
