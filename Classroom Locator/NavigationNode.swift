
import SceneKit

class NavigationNode: SCNNode {

    let arrow: SCNPyramid
    let arrowNode: SCNNode
    var target: SCNNode?

    override init() {
        arrow = SCNPyramid(width: 0.05, height: 0.2, length: 0.05)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        arrow.materials = [material]
        
        arrowNode = SCNNode()
        arrowNode.geometry = arrow
        arrowNode.rotation = SCNVector4(-1.0, 0, 0, Double.pi/2)
            
        super.init()

        self.addChildNode(arrowNode)
        self.isHidden = true
        //self.geometry = arrow
        self.opacity = 0.9
        //self.rotation = SCNVector4(0, 1.0, 0, Double.pi/2)
        self.position = SCNVector3(0, -0.2 ,-0.5)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        self.isHidden = false
    }

    func hide() {
        self.isHidden = true
    }

    func setTarget(_ targetNode: SCNNode) {
        let constraint = SCNLookAtConstraint(target:targetNode)
        constraint.isGimbalLockEnabled = false
        self.target = targetNode
        self.constraints = [constraint]
    }

}
