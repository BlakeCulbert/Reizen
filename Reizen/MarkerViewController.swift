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
