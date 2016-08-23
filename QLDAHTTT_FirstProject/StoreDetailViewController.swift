//
//  StoreDetailViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/16/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit

enum TravelModes: Int {
    case driving
    case walking
    case bicycling
}

class StoreDetailViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbGetDirection: UILabel!
    var getDirectionButton:MKButton = MKButton()
    var backButton:MKButton = MKButton()
    var mapTypeButton:MKButton = MKButton()
    var travelerButton:MKButton = MKButton()
    var infoButton:MKButton = MKButton()
    var mapTypeNormal:MKButton = MKButton()
    var mapTypeSatellite:MKButton = MKButton()
    var mapTypeHybrid:MKButton = MKButton()
    var travelDriving:MKButton = MKButton()
    var travelWalking:MKButton = MKButton()
    var travelBicycling:MKButton = MKButton()
    
    //Check expended buttons
    var isMapTypeExpended:Bool = false
    var isTravellerExpended:Bool = false
    
    //Variable
    let locationManager = CLLocationManager()
    var storeFileArray:NSMutableArray = NSMutableArray()
    var currentAddress:String = String()
    var mapTasks = MapTasks()
    var originMarker: GMSMarker!
    var destinationMarker: GMSMarker!
    var routePolyline: GMSPolyline!
    
    var travelMode = TravelModes.driving

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make delegate and request access
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        //Write navigation title as Store Name
        var storeObject:PFObject = storeFileArray.objectAtIndex(0) as! PFObject
        if let storeName = storeObject["StoreName"] as? String {
            self.navigationItem.title = "\(storeName) Store"
        }
        
        
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        // Config button
        getDirectionButton.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        getDirectionButton.backgroundColor = UIColor.MKColor.Green
        getDirectionButton.layer.shadowOpacity = 0.75
        getDirectionButton.layer.shadowRadius = 3.5
        getDirectionButton.layer.shadowColor = UIColor.blackColor().CGColor
        getDirectionButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        getDirectionButton.setTitle("Get Direction", forState: UIControlState.Normal)
        getDirectionButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        getDirectionButton.addTarget(self, action: "getDirectionClick:", forControlEvents: UIControlEvents.TouchUpInside)
        //var rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: getDirectionButton)
        //self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        getDirectionButton.enabled = false
        getDirectionButton.alpha = 0
        
        mapTypeButton.frame = CGRect(x: 0, y: 0, width: dvWidth/3, height: getDirectionButton.frame.height)
        mapTypeButton.backgroundColor = UIColor.MKColor.Blue
        mapTypeButton.layer.shadowOpacity = 0.75
        mapTypeButton.layer.shadowRadius = 3.5
        mapTypeButton.layer.shadowColor = UIColor.blackColor().CGColor
        mapTypeButton.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        mapTypeButton.setTitle("Map Type", forState: UIControlState.Normal)
        mapTypeButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        mapTypeButton.addTarget(self, action: "mapTypeClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(mapTypeButton)
        
        travelerButton.frame = CGRect(x: mapTypeButton.frame.width, y: 0, width: dvWidth/3, height: getDirectionButton.frame.height)
        travelerButton.backgroundColor = UIColor.MKColor.Cyan
        travelerButton.layer.shadowOpacity = 0.75
        travelerButton.layer.shadowRadius = 3.5
        travelerButton.layer.shadowColor = UIColor.blackColor().CGColor
        travelerButton.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        travelerButton.setTitle("Direction", forState: UIControlState.Normal)
        travelerButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        travelerButton.addTarget(self, action: "travlerClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(travelerButton)
        
        infoButton.frame = CGRect(x: mapTypeButton.frame.width + travelerButton.frame.width, y: 0, width: dvWidth/3, height: getDirectionButton.frame.height)
        infoButton.backgroundColor = UIColor.MKColor.Teal
        infoButton.layer.shadowOpacity = 0.75
        infoButton.layer.shadowRadius = 3.5
        infoButton.layer.shadowColor = UIColor.blackColor().CGColor
        infoButton.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        infoButton.setTitle("Information", forState: UIControlState.Normal)
        infoButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        infoButton.addTarget(self, action: "infoClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(infoButton)
        
        // Map Style
        mapTypeNormal.frame = CGRect(x: mapTypeButton.frame.width/2, y: mapTypeButton.frame.height+1, width: 0, height: getDirectionButton.frame.height)
        mapTypeNormal.backgroundColor = UIColor.MKColor.Blue
        mapTypeNormal.layer.shadowOpacity = 0.75
        mapTypeNormal.layer.shadowRadius = 3.5
        mapTypeNormal.layer.shadowColor = UIColor.blackColor().CGColor
        mapTypeNormal.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        mapTypeNormal.setTitle("Normal", forState: UIControlState.Normal)
        mapTypeNormal.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        mapTypeNormal.addTarget(self, action: "mapTypeNormalClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(mapTypeNormal)
        mapTypeNormal.alpha = 0
        mapTypeNormal.enabled = false
        
        mapTypeSatellite.frame = CGRect(x: mapTypeButton.frame.width/2, y: mapTypeButton.frame.height*2+1, width: 0, height: getDirectionButton.frame.height)
        mapTypeSatellite.backgroundColor = UIColor.MKColor.Blue
        mapTypeSatellite.layer.shadowOpacity = 0.75
        mapTypeSatellite.layer.shadowRadius = 3.5
        mapTypeSatellite.layer.shadowColor = UIColor.blackColor().CGColor
        mapTypeSatellite.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        mapTypeSatellite.setTitle("Satellite", forState: UIControlState.Normal)
        mapTypeSatellite.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        mapTypeSatellite.addTarget(self, action: "mapTypeSatelliteClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(mapTypeSatellite)
        mapTypeSatellite.alpha = 0
        mapTypeSatellite.enabled = false
        
        mapTypeHybrid.frame = CGRect(x: mapTypeButton.frame.width/2, y: mapTypeButton.frame.height*3+1, width: 0, height: getDirectionButton.frame.height)
        mapTypeHybrid.backgroundColor = UIColor.MKColor.Blue
        mapTypeHybrid.layer.shadowOpacity = 0.75
        mapTypeHybrid.layer.shadowRadius = 3.5
        mapTypeHybrid.layer.shadowColor = UIColor.blackColor().CGColor
        mapTypeHybrid.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        mapTypeHybrid.setTitle("Hybrid", forState: UIControlState.Normal)
        mapTypeHybrid.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        mapTypeHybrid.addTarget(self, action: "mapTypeHybridClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(mapTypeHybrid)
        mapTypeHybrid.alpha = 0
        mapTypeHybrid.enabled = false
        
        // Travel Modes
        travelDriving.frame = CGRect(x: travelerButton.frame.origin.x + travelerButton.frame.width/2, y: travelerButton.frame.height+1, width: 0, height: getDirectionButton.frame.height)
        travelDriving.backgroundColor = UIColor.MKColor.Cyan
        travelDriving.layer.shadowOpacity = 0.75
        travelDriving.layer.shadowRadius = 3.5
        travelDriving.layer.shadowColor = UIColor.blackColor().CGColor
        travelDriving.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        travelDriving.setTitle("Driving", forState: UIControlState.Normal)
        travelDriving.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        travelDriving.addTarget(self, action: "travelDrivingClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(travelDriving)
        travelDriving.alpha = 0
        travelDriving.enabled = false

        travelWalking.frame = CGRect(x: travelerButton.frame.origin.x + travelerButton.frame.width/2, y: travelerButton.frame.height*2+1, width: 0, height: getDirectionButton.frame.height)
        travelWalking.backgroundColor = UIColor.MKColor.Cyan
        travelWalking.layer.shadowOpacity = 0.75
        travelWalking.layer.shadowRadius = 3.5
        travelWalking.layer.shadowColor = UIColor.blackColor().CGColor
        travelWalking.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        travelWalking.setTitle("Walking", forState: UIControlState.Normal)
        travelWalking.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        travelWalking.addTarget(self, action: "travelWalkingClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(travelWalking)
        travelWalking.alpha = 0
        travelWalking.enabled = false
        
        travelBicycling.frame = CGRect(x: travelerButton.frame.origin.x + travelerButton.frame.width/2, y: travelerButton.frame.height*3+1, width: 0, height: getDirectionButton.frame.height)
        travelBicycling.backgroundColor = UIColor.MKColor.Cyan
        travelBicycling.layer.shadowOpacity = 0.75
        travelBicycling.layer.shadowRadius = 3.5
        travelBicycling.layer.shadowColor = UIColor.blackColor().CGColor
        travelBicycling.layer.shadowOffset = CGSize(width: 1.0, height: 3)
        travelBicycling.setTitle("Bicycling", forState: UIControlState.Normal)
        travelBicycling.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 15)
        travelBicycling.addTarget(self, action: "travelBicyclingClick:", forControlEvents: UIControlEvents.TouchUpInside)
        self.mapView.addSubview(travelBicycling)
        travelBicycling.alpha = 0
        travelBicycling.enabled = false
        
        //Config label
        lbGetDirection.frame = CGRectMake(0, 0, dvWidth, 5)
        lbGetDirection.font = UIFont(name: "Helvetica-Light", size: 10)
        lbGetDirection.text = "Distance and Duration"
        lbGetDirection.textColor = UIColor.blackColor()
        lbGetDirection.alpha = 0.7
        
        // hide default navigation bar button item
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        addLeftNavItemOnView()

        // Update store user's location
        updateStoreLocation()
    }
    
    func getDirectionClick(sender:UIButton!) {
        println(currentAddress)
        if destinationMarker != nil {
            destinationMarker.map = nil
        }
        var storeObject:PFObject = storeFileArray.objectAtIndex(0) as! PFObject
        if let storeAddress = storeObject["StoreAddress"] as? String {
            getDirection(currentAddress, destination: storeAddress)
        }
    }
    
    func addLeftNavItemOnView (){
        // hide default navigation bar button item
        self.navigationItem.backBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backButton.backgroundColor = UIColor.MKColor.Green
        backButton.cornerRadius = 20.0
        backButton.backgroundLayerCornerRadius = 20.0
        backButton.maskEnabled = false
        backButton.circleGrowRatioMax = 1.75
        backButton.rippleLocation = .Center
        backButton.aniDuration = 0.85
        backButton.layer.shadowOpacity = 0.75
        backButton.layer.shadowRadius = 3.5
        backButton.layer.shadowColor = UIColor.blackColor().CGColor
        backButton.layer.shadowOffset = CGSize(width: 1.0, height: 5.5)
        backButton.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
        //backButton.setTitle("<", forState: UIControlState.Normal)
        //backButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 20)
        backButton.addTarget(self, action: "backButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        var leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
    }
    
    func backButtonClick(sender:UIButton!){
        self.storeFileArray.removeAllObjects()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func mapTypeClick(sender:UIButton!){
        if isMapTypeExpended == false {
            doExpandMapTypeStaff()
        } else {
            doCloseMapTypeStaff()
        }
        
    }
    
    func doExpandMapTypeStaff() {
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        isMapTypeExpended = true
        UIView.animateWithDuration(0.2, animations: {
            self.mapTypeNormal.alpha = 1
            self.mapTypeNormal.enabled = true
            self.mapTypeNormal.frame = CGRect(x: 0, y: self.mapTypeButton.frame.height+1, width: dvWidth/3, height: self.getDirectionButton.frame.height)
            }, completion: { finished in
                if finished {
                    UIView.animateWithDuration(0.2, animations: {
                        self.mapTypeSatellite.alpha = 1
                        self.mapTypeSatellite.enabled = true
                        self.mapTypeSatellite.frame = CGRect(x: 0, y: self.mapTypeButton.frame.height*2+1, width: dvWidth/3, height: self.getDirectionButton.frame.height)
                        }, completion: { finished in
                            if finished {
                                UIView.animateWithDuration(0.2, animations: {
                                    self.mapTypeHybrid.alpha = 1
                                    self.mapTypeHybrid.enabled = true
                                    self.mapTypeHybrid.frame = CGRect(x: 0, y: self.mapTypeButton.frame.height*3+1, width: dvWidth/3, height: self.getDirectionButton.frame.height)
                                    }, completion: { finished in
                                        if finished {
                                            
                                        }
                                })
                            }
                    })
                }
        })
    }
    
    func doCloseMapTypeStaff() {
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        isMapTypeExpended = false
        UIView.animateWithDuration(0.2, animations: {
            self.mapTypeHybrid.alpha = 1
            self.mapTypeHybrid.enabled = true
            self.mapTypeHybrid.frame = CGRect(x: self.mapTypeButton.frame.width/2, y: self.mapTypeHybrid.frame.height*3+1, width: 0, height: self.getDirectionButton.frame.height)
            }, completion: { finished in
                if finished {
                    UIView.animateWithDuration(0.2, animations: {
                        self.mapTypeSatellite.alpha = 1
                        self.mapTypeSatellite.enabled = true
                        self.mapTypeSatellite.frame = CGRect(x: self.mapTypeButton.frame.width/2, y: self.mapTypeButton.frame.height*2+1, width: 0, height: self.getDirectionButton.frame.height)
                        }, completion: { finished in
                            if finished {
                                UIView.animateWithDuration(0.2, animations: {
                                    self.mapTypeNormal.alpha = 1
                                    self.mapTypeNormal.enabled = true
                                    self.mapTypeNormal.frame = CGRect(x: self.mapTypeButton.frame.width/2, y: self.mapTypeButton.frame.height+1, width: 0, height: self.getDirectionButton.frame.height)
                                    }, completion: { finished in
                                        if finished {
                                            
                                        }
                                })
                            }
                    })
                }
        })
    }
    
    func travlerClick(sender:UIButton!){
        if isTravellerExpended == false {
            doExpandTravllerStaff()
        } else {
            doCloseTravllerStaff()
        }

    }
    
    func doExpandTravllerStaff() {
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        
        isTravellerExpended = true
        UIView.animateWithDuration(0.2, animations: {
            self.travelDriving.alpha = 1
            self.travelDriving.enabled = true
            self.travelDriving.frame = CGRect(x: self.travelerButton.frame.origin.x, y: self.travelerButton.frame.height+1, width: self.travelerButton.frame.width, height: self.getDirectionButton.frame.height)
            }, completion: { finished in
                if finished {
                    UIView.animateWithDuration(0.2, animations: {
                        self.travelWalking.alpha = 1
                        self.travelWalking.enabled = true
                        self.travelWalking.frame = CGRect(x: self.travelerButton.frame.origin.x, y: self.travelerButton.frame.height*2+1, width: self.travelerButton.frame.width, height: self.getDirectionButton.frame.height)
                        }, completion: { finished in
                            if finished {
                                UIView.animateWithDuration(0.2, animations: {
                                    self.travelBicycling.alpha = 1
                                    self.travelBicycling.enabled = true
                                    self.travelBicycling.frame = CGRect(x: self.travelerButton.frame.origin.x, y: self.travelerButton.frame.height*3+1, width: self.travelerButton.frame.width, height: self.getDirectionButton.frame.height)
                                    }, completion: { finished in
                                        if finished {
                                            
                                        }
                                })
                            }
                    })
                }
        })
    }
    
    func doCloseTravllerStaff() {
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height
        isTravellerExpended = false
        UIView.animateWithDuration(0.2, animations: {
            self.travelBicycling.alpha = 1
            self.travelBicycling.enabled = true
            self.travelBicycling.frame = CGRect(x: self.travelerButton.frame.origin.x + self.travelerButton.frame.width/2, y: self.travelerButton.frame.height*3+1, width: 0, height: self.getDirectionButton.frame.height)
            }, completion: { finished in
                if finished {
                    UIView.animateWithDuration(0.2, animations: {
                        self.travelWalking.alpha = 1
                        self.travelWalking.enabled = true
                        self.travelWalking.frame = CGRect(x: self.travelerButton.frame.origin.x + self.travelerButton.frame.width/2, y: self.travelerButton.frame.height*2+1, width: 0, height: self.getDirectionButton.frame.height)
                        }, completion: { finished in
                            if finished {
                                UIView.animateWithDuration(0.2, animations: {
                                    self.travelDriving.alpha = 1
                                    self.travelDriving.enabled = true
                                    self.travelDriving.frame = CGRect(x: self.travelerButton.frame.origin.x + self.travelerButton.frame.width/2, y: self.travelerButton.frame.height+1, width: 0, height: self.getDirectionButton.frame.height)
                                    }, completion: { finished in
                                        if finished {
                                            
                                        }
                                })
                            }
                    })
                }
        })
    }
    
    func infoClick(sender:UIButton!){
        self.performSegueWithIdentifier("StoreInfoSegue", sender: storeFileArray)
    }
    
    func mapTypeNormalClick(sender:UIButton!) {
        mapView.mapType = kGMSTypeNormal
        //doCloseMapTypeStaff()
    }
    
    func mapTypeSatelliteClick(sender:UIButton!) {
        mapView.mapType = kGMSTypeSatellite
        //doCloseMapTypeStaff()
    }
    
    func mapTypeHybridClick(sender:UIButton!) {
        mapView.mapType = kGMSTypeHybrid
        //doCloseMapTypeStaff()
    }
    
    func travelDrivingClick(sender:UIButton!) {
        self.travelMode = TravelModes.driving
        self.recreateRoute()
    }
    
    func travelWalkingClick(sender:UIButton!) {
        self.travelMode = TravelModes.walking
        self.recreateRoute()
    }
    
    func travelBicyclingClick(sender:UIButton!) {
        self.travelMode = TravelModes.bicycling
        self.recreateRoute()
    }
    
    func recreateRoute() {
        if destinationMarker != nil {
            destinationMarker.map = nil
        }
        if let polyline = routePolyline {
            self.clearRoute()
        }
        var storeObject:PFObject = storeFileArray.objectAtIndex(0) as! PFObject
        if let storeAddress = storeObject["StoreAddress"] as? String {
            self.mapTasks.getDirections(self.currentAddress, destination: storeAddress, waypoints: nil, travelMode: travelMode, completionHandler: { (status, success) -> Void in
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                    self.displayRouteInfo()
                }
                else {
                    println(status)
                    if status == "ZERO_RESULTS" {
                        var alert = UIAlertController(title: "No Result", message: "We can't get route by this travel mode. Please try another modes", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func updateStoreLocation() {
        var storeObject:PFObject = storeFileArray.objectAtIndex(0) as! PFObject
        if let storeAddress = storeObject["StoreAddress"] as? String {
            mapTasks.geocodeAddress(storeAddress, withCompletionHandler: { (status, success) -> Void in
                if success == true {
                    //println(status)
                    if status == "ZERO_RESULTS" {
                        println("The location could not be found")
                    } else {
                        let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                        self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 13)
                        self.setupLocationMarker(coordinate)
                    }
                }
            })
        }
    }
    
    func getDirection(origin: String, destination: String) {
        self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
            if success {
                self.configureMapAndMarkersForRoute()
                self.drawRoute()
                self.displayRouteInfo()
            }
            else {
                //println(status)
            }
        })
    }
    
    func configureMapAndMarkersForRoute() {
        mapView.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 13.0)
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.mapView
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.mapView
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = self.mapTasks.destinationAddress
    }
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = mapView
    }
    
    func displayRouteInfo() {
        println("\(mapTasks.totalDistance) + and + \(mapTasks.totalDuration)")
        lbGetDirection.text = mapTasks.totalDistance + " and " + mapTasks.totalDuration
    }
    
    func clearRoute() {
            originMarker.map = nil
            destinationMarker.map = nil
            routePolyline.map = nil
        
            originMarker = nil
            destinationMarker = nil
            routePolyline = nil
    }

    // Declare delegate for CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        // Verify granted permission
        if status == .AuthorizedWhenInUse {
            
            // Update user's location
            locationManager.startUpdatingLocation()
            
            // Draws light blue dot where the user is located
            mapView.myLocationEnabled = true
            // Adds a button to the map that centers the user's location when tapped
            mapView.settings.myLocationButton = true
        }
    }
    
    // Executes this when the location manager receives new location data
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations.first as? CLLocation {
            
            // Updates the map's camera to center around the user's location.
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)

            // Stop updating location
            locationManager.stopUpdatingLocation()
            reverseGeocodeCoordinate(location.coordinate)
        }
    }
    
    func reverseGeocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        
        // Turn a latitude and longitude coordinate into a street address
        let geocoder = GMSGeocoder()
        
        // Reverse geocode the coordinate passed to the method.
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                // Set text
                let lines = address.lines as! [String]
                self.currentAddress = join("\n", lines)
            }
        }
    }
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        destinationMarker = GMSMarker(position: coordinate)
        destinationMarker.map = mapView
        destinationMarker.title = mapTasks.fetchedFormattedAddress
        destinationMarker.appearAnimation = kGMSMarkerAnimationPop
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        destinationMarker.opacity = 0.75
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StoreInfoSegue"){
            var infoStore:StoreInformationViewController = segue.destinationViewController as! StoreInformationViewController
            infoStore.storeFileArray = sender as! NSMutableArray
        }
    }
}
