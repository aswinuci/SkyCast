// View Controller
// @Aswin Sampath

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation

class ViewController: UIViewController , CLLocationManagerDelegate{

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!

    @IBOutlet weak var selectLocationButton: UIButton!
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "8c1e240150949fb7bfe0bf0503c8a20e"
    var lat = 11.344533
    var lon = 104.33322
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager() // for getting user's location
    
    var isNavSelected = false
    var inputCity = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        backgroundView.layer.addSublayer(gradientLayer)
        
        selectLocationButton.layer.cornerRadius = 10
        selectLocationButton.layer.masksToBounds = true
        selectLocationButton.backgroundColor = UIColor.systemGray;
        selectLocationButton.layer.borderWidth = 1.0
        selectLocationButton.layer.borderColor = UIColor.black.cgColor
        let darkishWhiteColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        selectLocationButton.setTitleColor(darkishWhiteColor, for: .normal)

        
        if self.isNavSelected == false {
            
            //Setting up the dialog box
            let indicatorSize: CGFloat = 70
            let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.height-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
            activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
            activityIndicator.backgroundColor = UIColor.black
            view.addSubview(activityIndicator)
            
            locationManager.requestWhenInUseAuthorization()
            
            //Getting user's current location
            activityIndicator.startAnimating()
            if(CLLocationManager.locationServicesEnabled()){
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                
            }
        }
        else{
            getWeatherDataForCiyWithLatAndLon(latitude: lat, longitude: lon)
        }
    }
    
    //This method is called whenever the location info is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
        getWeatherDataForCiyWithLatAndLon(latitude: lat, longitude: lon)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    /*This is a user defined method and it does following
     1. Makes the api call basis latitute and longitude values
     2. Parse the json response using SwiftJSON
     3. Populate storyboard elements based on response received
     */
    func getWeatherDataForCiyWithLatAndLon(latitude: Double, longitude: Double){
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric").responseJSON{
            
            response in
            if self.isNavSelected == false {
                self.activityIndicator.stopAnimating()
            }
            if let responseStr = response.result.value{
                let response = JSON(responseStr)
                let weather = response["weather"].array![0]
                let temparature = response["main"]
                let icon = weather["icon"].stringValue
                
                self.conditionLabel.text = weather["main"].stringValue
                if self.isNavSelected {
                    self.locationLabel.text = self.inputCity
                }
                else{
                    self.locationLabel.text = response["name"].stringValue
                }
                self.conditionImageView.image = UIImage(named: icon)
                self.temperatureLabel.text = "\(Int(round(temparature["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = icon.suffix(1)
                if(suffix == "n"){
                    self.setGreyGradientBackground()
                }
                else{
                    self.setBlueGradientBackground()
                    self.selectLocationButton.backgroundColor = UIColor.systemTeal;
                }
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    //This method sets the blue gradient background when it is day
    func setBlueGradientBackground(){
        let topColor = UIColor(red: 95.0/255.0, green:165.0/255.0, blue:1.0, alpha:1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green:114.0/255.0, blue:184.0/255.0, alpha:1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    //This method sets the grey gradient background when it is night
    func setGreyGradientBackground(){
        let topColor = UIColor(red: 151.0/255.0, green:151.0/255.0, blue:151.0/255.0, alpha:1.0).cgColor
        let bottomColor = UIColor(red: 72.0/255.0, green:72.0/255.0, blue:72.0/255.0, alpha:1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    
}

