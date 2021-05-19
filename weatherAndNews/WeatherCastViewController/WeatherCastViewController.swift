//
//  WeatherCastViewController.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 17/05/21.
//

import UIKit
import CoreLocation
import MapKit

class WeatherCastViewController: UIViewController, CLLocationManagerDelegate  {
    @IBOutlet var table : UITableView!
    @IBOutlet var weatherIconToday : UIImageView!
    @IBOutlet var labelToday : UILabel!
    @IBOutlet var locationToday : UILabel!
    @IBOutlet var tempToday : UILabel!
    @IBOutlet var hourlyView : UICollectionView!
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var latitude : Double = 0
    var longitude : Double = 0
    var models = [Daily]()
    var hourlyData = [Current]()
    var currentData : Current?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.register(UINib(nibName: "WeatherCellTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherCellTableViewCell.identifier)
 
        hourlyView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        hourlyView.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        hourlyView.delegate = self
        hourlyView.dataSource = self
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        setupLocation()
        
    }

    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func setCurrentData(){
        guard let currentData = currentData else{return}
        weatherIconToday.setImage(urlString: currentData.weather[0].icon)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + "," + country)  // Rio de Janeiro, Brazil
            self.locationToday.text = "\(city), \(country)"
            self.tempToday.text = "\(Int(currentData.temp))°C"
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("I am inside")
        if !locations.isEmpty,currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            requestForWeather()
        }
    }
    func setImage(urlString:String,myImage:UIImageView){
        let iconurl = "http://openweathermap.org/img/w/" + urlString + ".png";
        guard let iconurl = URL(string: iconurl) else {
            return
        }
        let data = try? Data(contentsOf: iconurl)

        if let imageData = data {
            let image = UIImage(data: imageData)
           myImage.image = image
        }
    }
    func requestForWeather(){
        guard let currentLocation = currentLocation else{
            print("REt")
            return
        }
        let longitude = currentLocation.coordinate.longitude
        let latitude = currentLocation.coordinate.latitude
        print(latitude,longitude)

        
let url = generateURL(with: latitude, and: longitude)
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data,response,error in
            
            guard let data = data, error == nil else{
                return
            }
            
            var json: WeatherResponse?
            do{
                json = try JSONDecoder().decode(WeatherResponse.self,from:data)
            }catch{
                print("ERRORs")
            }
            guard let fetchedData = json else{ return }
            print(fetchedData.timezoneOffset)
            let result = fetchedData.daily
            self.models.append(contentsOf: result)
            self.currentData = fetchedData.current
            self.latitude = fetchedData.lat
            self.longitude = fetchedData.lon
            self.hourlyData = fetchedData.hourly
            DispatchQueue.main.async {
                self.table.reloadData()
                self.setCurrentData()
                self.hourlyView.reloadData()
            }
            
        }).resume()
       
    }
    
    func generateURL(with lat:Double, and long: Double)->String{
//        lat=8.699525&lon=77.516735
        return "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&units=metric&appid=3540e704b9a91cce081155a9f4acefc6"
    }
}
extension WeatherCastViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: WeatherCellTableViewCell.identifier,for: indexPath) as! WeatherCellTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
}
extension WeatherCastViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let frameHeight = (view.frame.height * 15)/100
//        return CGSize(width: frameHeight*0.667, height: frameHeight)
        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData .count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        cell.configure(with: hourlyData[indexPath.row])
        return cell
    }
    
    
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
extension UIImageView {
    func setImage(urlString:String){
        let iconurl = "http://openweathermap.org/img/w/" + urlString + ".png";
        guard let iconurl = URL(string: iconurl) else {
            return
        }
        let data = try? Data(contentsOf: iconurl)

        if let imageData = data {
            let image = UIImage(data: imageData)
           self.image = image
        }
    }
}
extension StringProtocol {
    var firstUppercased: String { prefix(1).uppercased() + dropFirst() }
    var firstCapitalized: String { prefix(1).capitalized + dropFirst() }
}
