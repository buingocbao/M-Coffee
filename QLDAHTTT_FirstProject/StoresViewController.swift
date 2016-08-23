//
//  StoresViewController.swift
//  QLDAHTTT_FirstProject
//
//  Created by BBaoBao on 5/15/15.
//  Copyright (c) 2015 buingocbao. All rights reserved.
//

import UIKit
import MapKit

class StoresViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var storesFileArray:NSArray = NSArray()

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var mapSegment: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addressLabel: UILabel!
    //Adds a constant property
    var refreshControl: UIRefreshControl!
    let locationManager = CLLocationManager()
    var storeFileArrayToSegue:NSMutableArray = NSMutableArray()
    var currentAddress:String = String()
    
    var distances:NSMutableArray = NSMutableArray()
    
    //Make custom location
    var mapTasks = MapTasks()
    var locationMarker: GMSMarker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make clear store object array
        storeFileArrayToSegue.removeAllObjects()

        //Make delegate and request access
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.delegate = self
        
        //Get device size
        var bounds: CGRect = UIScreen.mainScreen().bounds
        var dvWidth:CGFloat = bounds.size.width
        var dvHeight:CGFloat = bounds.size.height

        //Config label
        addressLabel.frame = CGRectMake(0, mapView.frame.height, dvWidth, 5)
        addressLabel.font = UIFont(name: "Helvetica-Light", size: 10)
        addressLabel.text = "Address is here"
        addressLabel.textColor = UIColor.blackColor()
        
        // Config Refresh Control
        self.refreshControl = UIRefreshControl()
        //self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("tableRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor.blackColor()
        self.tableView.addSubview(refreshControl)
        
        // Update current user's location
        updateLocation()
        
        //Config tableView
        tableView.delegate = self
        tableView.dataSource = self
        //Get data from Parse
        queryParseMethod()
    }
    
    func queryParseMethod() {
        println("Start query")
        var query = PFQuery(className: "Stores")
        query.orderByAscending("StoreID")
        query.findObjectsInBackgroundWithBlock {
            (objects, error) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) hot stores.")
                self.storesFileArray = objects!
                //println(self.drinksFileArray)
            }
            
            self.tableView.reloadData()
            
            // Find and place markers on stores
            self.searchStores()
        }
    }
    
    // imageRefresh function
    func tableRefresh() {
        queryParseMethod()
        self.refreshControl.endRefreshing()
    }
    
    func updateLocation() {
        // Update user's location
        locationManager.startUpdatingLocation()
        
        // Draws light blue dot where the user is located
        mapView.myLocationEnabled = true
        // Adds a button to the map that centers the user's location when tapped
        mapView.settings.myLocationButton = true
    }
    
    // Search every stores and do finding method
    func searchStores() {
        for index in 0...storesFileArray.count-1 {
            println(index)
            var storeObject:PFObject = storesFileArray.objectAtIndex(index) as! PFObject
            if let storeAddress = storeObject["StoreAddress"] as? String {
                markStoresLocation(storeAddress)
            }
        }
    }
    
    // Find store location and place a marker
    func markStoresLocation(address: String) {
        mapTasks.geocodeAddress(address, withCompletionHandler: { (status, success) -> Void in
            if success == true {
                println(status)
                if status == "ZERO_RESULTS" {
                    println("The location could not be found")
                } else {
                    let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                    //self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 15)
                    self.setupLocationMarker(coordinate)
                }
            }
        })
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
            
            // Get current user's address
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
                self.addressLabel.text = join("\n", lines)
                self.currentAddress = join("\n", lines)
                
                // Animate the changes in the label
                UIView.animateWithDuration(0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func mapView(mapView: GMSMapView!, idleAtCameraPosition position: GMSCameraPosition!) {
        reverseGeocodeCoordinate(position.target)
    }
    //
    
    func setupLocationMarker(coordinate: CLLocationCoordinate2D) {
        locationMarker = GMSMarker(position: coordinate)
        locationMarker.map = mapView
        locationMarker.title = mapTasks.fetchedFormattedAddress
        locationMarker.appearAnimation = kGMSMarkerAnimationPop
        locationMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        locationMarker.opacity = 0.75
    }
    
    // Config table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storesFileArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("StoresCell") as! StoresTableViewCell!
        if cell == nil {
            cell = StoresTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "StoresCell")
        }
        
        var storeObject:PFObject = storesFileArray.objectAtIndex(indexPath.row) as! PFObject
        
        // Config cell
        //cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.lbDistance.alpha = 0
        
        // Extract values from the PFObject to display in the table cell
        if let storeName = storeObject["StoreName"] as? String {
            cell.lbStoreName.text = storeName
        }
        if let storeAddress = storeObject["StoreAddress"] as? String {
            cell.lbStoreAddress.text = storeAddress
            //println(self.currentAddress)
            /*
            self.mapTasks.getDirections(currentAddress, destination: storeAddress, waypoints: nil, travelMode: nil, completionHandler: { (status, success) -> Void in
                if success {
                    cell.lbDistance.text = self.mapTasks.totalDistance.stringByReplacingOccurrencesOfString("Total Distance: ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                }
                else {
                    println(status)
                }
            })*/
        }
        if let storeClose = storeObject["StoreCloseHour"] as? Int {
            cell.lbStoreClose.text = "Store closed until \(storeClose):00 PM"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        //var storeObjects:PFObject = storesFileArray.objectAtIndex(indexPath.row) as! PFObject
        storeFileArrayToSegue.addObject(storesFileArray.objectAtIndex(indexPath.row))
        self.performSegueWithIdentifier("StoreDetailSegue", sender: storeFileArrayToSegue)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var storeObject:PFObject = storesFileArray.objectAtIndex(indexPath.row) as! PFObject
        if let storeAddress = storeObject["StoreAddress"] as? String {
            mapTasks.geocodeAddress(storeAddress, withCompletionHandler: { (status, success) -> Void in
                if success == true {
                    println(status)
                    
                    if status == "ZERO_RESULTS" {
                        println("The location could not be found")
                    } else {
                        let coordinate = CLLocationCoordinate2D(latitude: self.mapTasks.fetchedAddressLatitude, longitude: self.mapTasks.fetchedAddressLongitude)
                        self.mapView.camera = GMSCameraPosition.cameraWithTarget(coordinate, zoom: 15)
                    }
                }
            })
        }
    }
    
    //Change Map view type
    @IBAction func mapTypeSegmentPressed(sender: AnyObject) {
        let segmentedControl = sender as! UISegmentedControl
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = kGMSTypeNormal
        case 1:
            mapView.mapType = kGMSTypeSatellite
        case 2:
            mapView.mapType = kGMSTypeHybrid
        default:
            mapView.mapType = mapView.mapType
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StoreDetailSegue"){
            var detailStore:StoreDetailViewController = segue.destinationViewController as! StoreDetailViewController
            detailStore.storeFileArray = sender as! NSMutableArray
        }
    }
}
