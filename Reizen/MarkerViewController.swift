//
//  MarkerViewController.swift
//  Reizen
//
//  Created by Blake Culbert on 11/4/20.
//

import UIKit
import FirebaseDatabase

class MarkerViewController: UIViewController {
    
    @IBOutlet weak var markerXLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let markerX = UserDefaults.standard.float(forKey: "Key")
        
        let ref = Database.database().reference()
        
        switch markerX {
        case -2.1261265:
            print("hello")
            // markerXLabel.text = "Wonderland Trail"
            ref.child("WonderlandTrail/description").observeSingleEvent(of: .value, with: { (snapshot) in
                self.markerXLabel.text = snapshot.value as? String
                
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
