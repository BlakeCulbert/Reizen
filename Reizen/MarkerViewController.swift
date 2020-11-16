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
    

    @IBOutlet weak var hikeTitle: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var hikeDescription: UILabel!
    
    @IBOutlet weak var length: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let markerX = UserDefaults.standard.float(forKey: "Key")
        
        let dataRef = Database.database().reference()
        
        let storageRef = Storage.storage().reference()
        
        
        switch markerX {
        case -2.1261265:
            
            let imageList = ["images/wonderland1.jpg", "images/wonderland2.jpg"]
            
            dataRef.child("WonderlandTrail/title").observeSingleEvent(of: .value, with: { (snapshot) in
                self.hikeTitle.text = snapshot.value as? String
            })
            
            var imgCount = 0
            
            for item in imageList {
                let sRef = storageRef.child(item)
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
            
            dataRef.child("WonderlandTrail/description").observeSingleEvent(of: .value, with: { (snapshot) in
                self.hikeDescription.text = snapshot.value as? String
            })
            
            dataRef.child("WonderlandTrail/length").observeSingleEvent(of: .value, with: { (snapshot) in
                self.length.text = snapshot.value as? String
            })
            
        default:
            print("no")
        }
        // Do any additional setup after loading the view.
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
