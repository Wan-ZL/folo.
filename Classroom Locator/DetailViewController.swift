
import UIKit
import Alamofire

class DetailViewController: UIViewController {
  
    @IBOutlet weak var courseCode: UILabel!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var online: UILabel!
    @IBOutlet weak var goToAR: UIButton!
    
  var detailLocation: UALocation? {
    didSet {
      configureView()
    }
  }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let name : String = (self.detailLocation?.locationName)!
        if name.lowercased() == "online"{
            online.text! = "Your class is online"
            goToAR.isEnabled = false
        }else{
            online.text! = ""
            Alamofire.request("https://cl.simino.xyz/v1/building/getBuilding", method : .get, parameters: ["name":name]).responseJSON { response in
                debugPrint(response)
                
                if let json = response.result.value as! NSDictionary? {
                    if let result = json["result"] as! NSArray? {
                        if result.count > 0 {
                            for one in result {
                                let oneDic = one as! NSDictionary
                                let la = oneDic["latitude"] as! String
                                let lo = oneDic["longitude"] as! String
                                let al = "710"
                                self.detailLocation?.latitude = la
                                self.detailLocation?.longitude = lo
                                self.detailLocation?.altitude = al
                            }
                            print("\(result[0])")
                        }
                    }
                    for (key, value) in json {
                        print("Value: \(value) for key: \(key)")
                    }
                }
            }
        }
    }
  
  func configureView() {
    if let detailLocation = detailLocation {
        if let courseCode = courseCode, let locationName = locationName{
            courseCode.text = "\(detailLocation.courseCode) \(detailLocation.courseNum), \(detailLocation.sectionNum)-\(detailLocation.courseType)"
            locationName.text = "\(detailLocation.locationName), \(detailLocation.roomNo)"
        }
    }
  }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAR"{
            
            if let nextViewController = segue.destination as? ARViewController{
                nextViewController.uaLoc = detailLocation!
            }
        }
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

