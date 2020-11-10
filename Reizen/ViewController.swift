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

        // we'll need this layer in a second
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
        
        layer.handleEdges = true
        layer.coverPoles = true
        layer.requireElev = false
        layer.waitLoad = false
        layer.drawPriority = 0
        layer.singleLevelLoading = false
        theViewC!.add(layer)
        
        // start up over Madrid, center of the old-world
        if let globeViewC = globeViewC {
            globeViewC.height = 0.8
            globeViewC.animate(toPosition: MaplyCoordinateMakeWithDegrees(-3.6704803,40.5023056), time: 1.0)
        }
        
      }
    
    private func hikeLocations() {
        // need coordinates for locations of hikes, add coords to list
        let locations = [
            MaplyCoordinateMakeWithDegrees(-122.4192,3.7793),
            MaplyCoordinateMakeWithDegrees(-77.036667, 38.895111),
            MaplyCoordinateMakeWithDegrees(120.966667, 14.583333),
            MaplyCoordinateMakeWithDegrees(55.75, 37.616667),
            MaplyCoordinateMakeWithDegrees(-0.1275, 51.507222),
            MaplyCoordinateMakeWithDegrees(-66.916667, 10.5),
            MaplyCoordinateMakeWithDegrees(139.6917, 35.689506),
            MaplyCoordinateMakeWithDegrees(166.666667, -77.85),
            MaplyCoordinateMakeWithDegrees(-58.383333, -34.6),
            MaplyCoordinateMakeWithDegrees(-74.075833, 4.598056),
            MaplyCoordinateMakeWithDegrees(-79.516667, 8.983333),
            MaplyCoordinateMakeWithDegrees(-5.7043173, 40.9634332)
        ]
        
        let icon = UIImage(named: "mountain_icon.png")
        
        icon?.accessibilityRespondsToUserInteraction = true;
        
        
        let markers = locations.map { cap -> MaplyScreenMarker in
                let marker = MaplyScreenMarker()
                marker.image = icon
                marker.loc = cap
                marker.size = CGSize(width: 40,height: 40)
                return marker
        
        }
        
        theViewC?.addScreenMarkers(markers, desc: nil)
        
    }
    
    private func addAnnotation(title: String, subtitle: String, loc: MaplyCoordinate) {
        theViewC?.clearAnnotations()
        
        let a = MaplyAnnotation()
        a.title = title
        a.subTitle = subtitle
        
        theViewC?.addAnnotation(a, forPoint: loc, offset: CGPoint.zero)
    }
    
    private func markerSelection(selectedObject: NSObject) {
        if let selectedObject = selectedObject as? MaplyVectorObject {
            let loc = selectedObject.centroid()
            if loc.x != kMaplyNullCoordinate.x {
                let title = "Selected:"
                let subtitle = selectedObject.userObject as! String
                addAnnotation(title: title, subtitle: subtitle, loc: loc)
            }
        }
        else if selectedObject is MaplyScreenMarker {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarkerViewController") as! MarkerViewController
            self.present(vc, animated: true, completion: nil)
        }
    }

    func globeViewController(_ viewC: WhirlyGlobeViewController, didTapAt coord: MaplyCoordinate) {
        let subtitle = NSString(format: "(%.2fN, %.2fE)", coord.y*57.296, coord.x*57.296) as String
        addAnnotation(title: "Tap!", subtitle: subtitle, loc: coord)
    }
    
    func globeViewController(_ viewC: WhirlyGlobeViewController, didSelect selectedObject: NSObject) {
        markerSelection(selectedObject: selectedObject)
    }
    
}
// test change for test commit.
