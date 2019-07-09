//
//  ViewController.swift
//  Poke3D
//
//  Created by Cássio Marcos Goulart on 04/07/19.
//  Copyright © 2019 CMG Solutions. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARImageTrackingConfiguration()

        if let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main) {
            configuration.trackingImages = imagesToTrack
            configuration.maximumNumberOfTrackedImages = 2
        }
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let imagePlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            imagePlane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let imageNode = SCNNode(geometry: imagePlane)
            imageNode.eulerAngles.x = -.pi/2
            
            node.addChildNode(imageNode)
            
            if let pokeName = imageAnchor.referenceImage.name,
                let pokeScene = SCNScene(named: "art.scnassets/\(pokeName)/\(pokeName).scn"),
                let pokeNode = pokeScene.rootNode.childNodes.first {
                
                var pokeScale = 1.0
                
                switch pokeName {
                case "Muk": pokeScale = 0.002
                case "Kangaskhan", "Koffing": pokeScale = 0.005
                case "Grimer": pokeScale = 0.0002
                default: pokeScale = 0.02
                }
                
                pokeNode.scale = SCNVector3(pokeScale, pokeScale, pokeScale)
                
                // TODO: test and fix Euler Angles for all the Pokemons.
                pokeNode.eulerAngles.x = .pi/2
                
                imageNode.addChildNode(pokeNode)
            }
        }
        
        return node
    }
    
    
}
