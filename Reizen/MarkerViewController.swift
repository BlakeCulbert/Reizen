//
//  MarkerViewController.swift
//  Reizen
//
//  Created by Blake Culbert on 11/4/20.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class MarkerViewController: UIViewController {
    
    // storyboard object outlets
    @IBOutlet weak var hikeTitle: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var hikeDescription: UILabel!
    @IBOutlet weak var length: UILabel!
    
    // database, storage references
    let dataRef = Database.database().reference()
    let storageRef = Storage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // from icon click, get location x-value
        let markerX = UserDefaults.standard.float(forKey: "Key")
        
        switch markerX {
        // Wonderland Trail case
        case -2.1261265:
            
            // parameters needed for getHikeData function
            let imageList = ["images/wonderland1.jpg", "images/wonderland2.jpg"]
            let hikeName = "WonderlandTrail"
            
            // get data
            getHikeData(hikeName: hikeName, imageList: imageList)
        
        // Kalalau Trail
        case -2.781321:
            
            let imageList = ["images/kalalau1.jpg", "images/kalalau2.jpg"]
            let hikeName = "Kalalau"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
        
        // Greenstone
        case -1.5537822:
            
            let imageList = ["images/greenstone1.jpg", "images/greenstone2.jpg"]
            let hikeName = "Greenstone"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
        
        // Panorama Ridge
        case -2.1461728:
            
            let imageList = ["images/panorama1.jpg", "images/panorama2.jpg"]
            let hikeName = "Panorama"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // Old Rag
        case -1.3722973:
            
            let imageList = ["images/oldrag1.jpg", "images/oldrag2.jpg"]
            let hikeName = "OldRag"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // South Maroon Peak
        case -1.8353447:
            
            let imageList = ["images/maroonpeak1.jpg", "images/maroonpeak2.jpg"]
            let hikeName = "MaroonPeak"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // Grand Canyon
        case -1.956741:
            
            let imageList = ["images/grandcanyon1.jpg", "images/grandcanyon2.jpeg"]
            let hikeName = "GrandCanyon"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // Lares Trek
        case -1.2574031:
            
            let imageList = ["images/lares1.jpg", "images/lares2.jpg"]
            let hikeName = "Lares"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // Paine Circuit
        case -1.2818245:
            
            let imageList = ["images/paine1.jpg", "images/paine2.jpg"]
            let hikeName = "Paine"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
            
        // Fisherfields
        case -0.095604025:
            
            let imageList = ["images/fisherfield1.jpg", "images/fisherfield2.jpg"]
            let hikeName = "Fisherfields"
            
            getHikeData(hikeName: hikeName, imageList: imageList)
        
        // default case
        default:
            print(markerX)
        }
        // Do any additional setup after loading the view.
    }
    
    // get description, title, length, and images from firebase
    private func getHikeData(hikeName: String, imageList: [String]) {
        
        // use database reference to get hike title
        dataRef.child("\(hikeName)/title").observeSingleEvent(of: .value, with: { (snapshot) in
            // update hikeTitle label to hike title
            self.hikeTitle.text = snapshot.value as? String
        })
        
        var imgCount = 0
        
        // for loop to load both images
        for item in imageList {
            // reference firebase storage
            let sRef = storageRef.child(item)
            // images up to 3 MB
            sRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("Image could not download!")
                }
                if imgCount == 0 {
                    let image = UIImage(data: data!)
                    self.image1.image = image
                }
                else {
                    let image = UIImage(data: data!)
                    self.image2.image = image
                }
                imgCount = 1
                
            })
        }
        
        // collect hike description from database
        dataRef.child("\(hikeName)/description").observeSingleEvent(of: .value, with: { (snapshot) in
            self.hikeDescription.text = snapshot.value as? String
        })
        
        // collect hike length from database
        dataRef.child("\(hikeName)/length").observeSingleEvent(of: .value, with: { (snapshot) in
            let dataLen = snapshot.value as! String
            self.length.text = "Length: \(dataLen)"
        })
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
