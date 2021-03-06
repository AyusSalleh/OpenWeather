//
//  ViewController.swift
//  CodingChallenge
//
//  Created by Ayus Salleh on 06/01/2017.
//  Copyright © 2017 SubZ3r0X. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreLocation

class ViewController: BaseViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var weatherTableView: UITableView!
    
    var defaults = UserDefaults.standard
    var locationManager: CLLocationManager!
    var geocoder: CLGeocoder!
    var placemark: CLPlacemark!
    var listArr = [Dictionary<String, Any>]()
    var dataIconArr = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupContinueBtn()
        self.navigationItem.title = "OpenWeatherMap"
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        weatherTableView.isHidden = true

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        showErrorMessage("Cannot Detect Your Location")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            locationManager.stopUpdatingLocation()
            CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemark, error) -> Void in
                if error == nil && placemark!.count > 0 {
                    let placemark = placemark![0]
                    
                    self.loadWeather(placemark.subAdministrativeArea!)
                    self.defaults.set(placemark.subAdministrativeArea!, forKey: "placeName")
                    self.defaults.synchronize()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if listArr.count != 0 {
            return 84
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listArr.count != 0 {
            return listArr.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if listArr.count != 0 {
            if let cell = weatherTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomWeatherTableViewCell {
                cell.weatherImg.image = UIImage(data: dataIconArr[indexPath.row])
                
                if let detailArr = listArr[indexPath.row]["weather"] as? [[String : Any]] {
                    if let weatherTypeOptional = detailArr[0]["main"] as? String {
                        cell.weatherType.text = weatherTypeOptional.capitalized
                    }
                    
                    if let weatherDescOptional = detailArr[0]["description"] as? String {
                        cell.weatherDesc.text = weatherDescOptional.capitalized
                    }
                }
                
                if let weatherTempArr = listArr[indexPath.row]["main"] as? [String : Any] {
                    if let weatherOptional = weatherTempArr["temp"] {
                        cell.weatherTemp.text = "\(weatherOptional)℃"
                    }
                }
                
                if let getDateTime = listArr[indexPath.row]["dt_txt"] as? String {
                    let f = DateFormatter()
                    f.locale = Locale(identifier: "en_GB")
                    f.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let hookDateTime = f.date(from: getDateTime)!
                    let stringDateTime = f.string(from: hookDateTime)
                    let separateDate = stringDateTime.components(separatedBy: " ")[0].components(separatedBy: "-")
                    let separateTime = stringDateTime.components(separatedBy: " ")[1].components(separatedBy: ":")
                    
                    let ampm = "\(stringDateTime)".components(separatedBy: " ")[1].components(separatedBy: ":")[0]
                    
                    if Int(ampm)! > 12 {
                        let getMonthFullName = Utility.sharedInstance.getMonthFullName(separateDate[1])
                        cell.weatherDateTime.text = "\(separateDate[2].replacingOccurrences(of: "0", with: "")) \(getMonthFullName) \(separateDate[0]) \(Int(separateTime[0])!-12):\(separateTime[1]):\(separateTime[2]) PM"
                    } else {
                        let getMonthFullName = Utility.sharedInstance.getMonthFullName(separateDate[1])
                        cell.weatherDateTime.text = "\(separateDate[2].replacingOccurrences(of: "0", with: "")) \(getMonthFullName) \(separateDate[0]) \(separateTime[0]):\(separateTime[1]):\(separateTime[2]) AM"
                    }
                }
                weatherTableView.isHidden = false
                self.hideHUD()
                return cell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if listArr.count != 0 {
            let storyboard2 = UIStoryboard(name: "Main", bundle: nil)

            if let DetailVC = storyboard2.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController {
                DetailVC.detailArr = listArr[indexPath.row]
                DetailVC.iconData = dataIconArr[indexPath.row]
                self.navigationController?.pushViewController(DetailVC, animated: true)
                self.weatherTableView.deselectRow(at: indexPath, animated: true)
            }

        }
    }
    
    func loadWeather(_ placeName: String) {
        self.showHUD()
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let appID = "4313c9069d1993cd4d9d379d3347b845"
        let newPlaceName = placeName.replacingOccurrences(of: " ", with: "")
        let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=\(newPlaceName)&units=metric&APPID=\(appID)")!
        
        let task = session.dataTask(with: url, completionHandler: { (data, _, error) in
            
            if error != nil {
                self.errorHUD()
                self.showErrorMessage(error!.localizedDescription)
                
            } else {
                
                do {
                    //let json = try JSON(JSONSerialization.jsonObject(with: successResult.data, options: .mutableContainers))

                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? Dictionary<String, Any> {
                        //Implement your logic
                        
                        if let responseCode = json["cod"] as? String {
                            
                            if responseCode == "200" {                                
                                
                                if let detailArr = json["list"] as? [Dictionary<String, Any>] {
                                    
                                    for detail in detailArr {
                                        self.listArr.append(detail)
                                        
                                        if let getWeatherDetail = detail["weather"] as? [[String : Any]] {
                                            if let iconID = getWeatherDetail[0]["icon"] as? String {
                                                if let url = URL(string: "http://openweathermap.org/img/w/\(iconID).png") {
                                                    if let data = try? Data(contentsOf: url) {
                                                        self.dataIconArr.append(data)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.weatherTableView.reloadData()
                                }
                                
                            } else {
                                self.errorHUD()
                                self.showRetryMessage("error")
                            }
                            
                        }
                    }
                    
                } catch {
                    self.errorHUD()
                    self.showErrorMessage("01")
                }
            }
        })
        task.resume()
    }
    
    func showRetryMessage(_ message: String) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Play-Bold", size: 14)!,
            kTextFont: UIFont(name: "Play", size: 14)!,
            kButtonFont: UIFont(name: "Play-Bold", size: 14)!,
            showCloseButton: false
        )
        
        let errorView = SCLAlertView(appearance: appearance)
        errorView.addButton("Retry") { () -> Void in
            let placeName = "\(self.defaults.object(forKey: "placeName")!)"
            self.loadWeather(placeName)
        }
        
        errorView.showError("Error!", subTitle:"Something wrong happened. Please try again :(", colorStyle: 0xFF0000)
    }
    
    func showErrorMessage(_ message: String) {
        
        // Create custom Appearance Configuration
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "Play-Bold", size: 14)!,
            kTextFont: UIFont(name: "Play", size: 14)!,
            kButtonFont: UIFont(name: "Play-Bold", size: 14)!,
            showCircularIcon: false
        )
        let errorView = SCLAlertView(appearance: appearance)
        
        if message == "01" {
            errorView.showError("Error!", subTitle: "Something wrong with configuration OpenWeather :(", closeButtonTitle : "Close", colorStyle: 0xFF0000)
        } else {
            errorView.showError("Error!", subTitle:message, closeButtonTitle : "Close", colorStyle: 0xFF0000)
        }
        
    }
}
