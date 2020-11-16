//
//  ViewController.swift
//  Reizen
//
//  Created by Blake Culbert on 10/13/20.
//

import UIKit

class ViewController: UIViewController,
                      WhirlyGlobeViewControllerDelegate{
    
    private var theViewC: MaplyBaseViewController?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create an empty globe and add it to the view
        theViewC = WhirlyGlobeViewController()
        self.view.addSubview(theViewC!.view)
        theViewC!.view.frame = self.view.bounds
        hikeLocations()
        
        let globeViewC = theViewC as? WhirlyGlobeViewController
        if let globeViewC = globeViewC {
            globeViewC.delegate = self
        }
        
        // we want a black background for a globe, a white background for a map.
        theViewC!.clearColor = (globeViewC != nil) ? UIColor.black : UIColor.white

        // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
        theViewC!.frameInterval = 2
        
        // add the capability to use the local tiles or remote tiles
        let useLocalTiles = false

        let layer: MaplyQuadImageTilesLayer

        if useLocalTiles {
            guard let tileSource = MaplyMBTileSource(mbTiles: "geography-class_medres") else {
                // can't load local tile set
            }
            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
        }
        else {
            // Because this is a remote tile set, we'll want a cache directory
            let baseCacheDir = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
            let tilesCacheDir = "\(baseCacheDir)/light_city"

            // Stamen Terrain Tiles, courtesy of Stamen Design under the Creative Commons Attribution License.
            // Data by OpenStreetMap under the Open Data Commons Open Database License.
            guard let tileSource = MaplyRemoteTileSource(
                    baseURL: "http://tile.stamen.com/terrain/",
                    ext: "png",
                    minZoom: 0,
                    maxZoom: 18) else {
                // can't create remote tile source
                return
            }
            tileSource.cacheDir = tilesCacheDir
            layer = MaplyQuadImageTilesLayer(tileSource: tileSource)!
        
        }
        
        // set globe properties
        layer.handleEdges = true
        layer.coverPoles = true
        layer.requireElev = false
        layer.waitLoad = false
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        theViewC!.add(layer)
        
        // start over the United States
        if let globeViewC = globeViewC {
            globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-100.230093, 38.685510), time: 1.0)
        }
        
      }
    
    private func hikeLocations() {
        // need coordinates for locations of hikes, add coords to list
        let locations = [
            // Wonderland Trail, Mount Rainier National Park, Washington
            MaplyCoordinateMakeWithDegrees(-121.818070, 46.737700),
            // Kalalau Trail, Kauai, Hawaii
            MaplyCoordinateMakeWithDegrees(-159.357956, 21.967581)
        ]
        
        // mountain icon
        let icon = UIImage(named: "mountain_icon.png")
        
        // enable user interaction on icon
        icon?.accessibilityRespondsToUserInteraction = true;
        
        // map markers on globe using coordinates in locations[]
        let markers = locations.map { cap -> MaplyScreenMarker in
                let marker = MaplyScreenMarker()
                marker.image = icon
                marker.loc = cap
                // size of marker
                marker.size = CGSize(width: 40,height: 40)
                return marker
        
        }
        
        theViewC?.addScreenMarkers(markers, desc: nil)
        
    }
    
    // display annotation on tap
    private func addAnnotation(title: String, subtitle: String, loc: MaplyCoordinate) {
        theViewC?.clearAnnotations()
        
        let a = MaplyAnnotation()
        a.title = title
        a.subTitle = subtitle
        
        theViewC?.addAnnotation(a, forPoint: loc, offset: CGPoint.zero)
    }
    
    // handle user selection on globe
    private func markerSelection(selectedObject: NSObject) {
        // when user does not select screen marker..
        if let selectedObject = selectedObject as? MaplyVectorObject {
            let loc = selectedObject.centroid()
            if loc.x != kMaplyNullCoordinate.x {
                let title = "Selected:"
                let subtitle = selectedObject.userObject as! String
                addAnnotation(title: title, subtitle: subtitle, loc: loc)
            }
        }
        // when the user selects a screen marker..
        else if selectedObject is MaplyScreenMarker, let selectedObject = selectedObject as? MaplyScreenMarker {
            let markerX = selectedObject.loc.x
            print(markerX)
            // send marker x-value to MarkerViewController
            UserDefaults.standard.set(markerX, forKey: "Key")
            // programmatically display MarkerViewController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarkerViewController") as! MarkerViewController
            // present vc
            present(vc, animated: true, completion: nil)
            
        }
    }

    // handle what annotation displays on user not tapping a screen marker
    func globeViewController(_ viewC: WhirlyGlobeViewController, didTapAt coord: MaplyCoordinate) {
        // show user coords
        let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296, coord.x*57.296) as String
        addAnnotation(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    // handle when user selects screen marker
    func globeViewController(_ viewC: WhirlyGlobeViewController, didSelect selectedObject: NSObject) {
        markerSelection(selectedObject: selectedObject)
    }
    
}
