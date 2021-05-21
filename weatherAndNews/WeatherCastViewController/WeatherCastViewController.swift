//
//  WeatherCastViewController.swift
//  weatherAndNews
//
//  Created by jeyaram-pt4154 on 17/05/21.
//

import UIKit
import CoreLocation
import MapKit
import DropDown

class WeatherCastViewController: UIViewController, CLLocationManagerDelegate  {
    @IBOutlet var table : UITableView!
    @IBOutlet var weatherIconToday : UIImageView!
    @IBOutlet var labelToday : UILabel!
    @IBOutlet weak var locationToday: DropDown!
    @IBOutlet var tempToday : UILabel!
    @IBOutlet var hourlyView : UICollectionView!
    @IBOutlet var currentView : CardView!
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var latitude : Double = 0
    var longitude : Double = 0
    var models = [Daily]()
    var hourlyData = [Current]()
    var currentData : Current?
    var cityCoordinates : [List]?
    var selectedCity : String = ""
    var dropDownArray = [String]()
    var dropDownId = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        navigationItem.searchController = UISearchController(searchResultsController: nil)
        table.register(UINib(nibName: "WeatherCellTableViewCell", bundle: nil), forCellReuseIdentifier: WeatherCellTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        
        hourlyView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        hourlyView.showsHorizontalScrollIndicator = false
        hourlyView.delegate = self
        hourlyView.dataSource = self
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        locationToday.borderStyle = .none
        setupLocation()
        
    }

    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
                case .notDetermined, .restricted, .denied:
                    requestAgain()
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                @unknown default:
                break
            }
            } else {
                print("Location services are not enabled")
        }
        locationManager.startUpdatingLocation()
    }
    func requestAgain(){
        // initialise a pop up for using later
            let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                 }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)

            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)

            // check the permission status
            switch(locationManager.authorizationStatus) {
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Authorize.")
                    // get the user location
                case .notDetermined, .restricted, .denied:
                    // redirect the users to settings
                    self.present(alertController, animated: true, completion: nil)
                @unknown default:
                break
            }
    }
    func setCurrentData(){
        guard let currentData = currentData else{return}
        weatherIconToday.setImage(urlString: currentData.weather[0].icon)
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { [self] city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.labelToday.text = getDayForDate(currentData.dt)
            selectedCity = "\(city), \(country)"
            self.locationToday.text = selectedCity
            self.tempToday.text = "\(Int(currentData.temp))°C"
        }
        self.locationToday.didSelect{(selectedText , index ,id) in
            self.selectedCity = self.locationToday.optionArray[index]
            let coordinateString = id.components(separatedBy: ",")
            self.latitude = Double(coordinateString[0]) ?? 0
            self.longitude = Double(coordinateString[1]) ?? 0
            self.requestForWeather(at: self.latitude, and: self.longitude)
        }
        locationToday.listDidDisappear {
            self.locationToday.text = self.selectedCity
        }
        
    }
    func getDayForDate(_ inputDate: Int) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        let date = Date(timeIntervalSince1970: Double(inputDate))
        
        let returnDate = formatter.string(from: date )
        
        return returnDate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
     
        if !locations.isEmpty,currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            guard let currentLocation = currentLocation else{return}
            latitude = currentLocation.coordinate.latitude
            longitude = currentLocation.coordinate.longitude
            requestForWeather(at: latitude, and: longitude)
            fetcharoundCities()
            fetchAllCountries()
        }
    }
    
    
    func requestForWeather(at lat:Double,and long:Double){
        
        let url = generateURL(with: lat, and: long,for: .singleCity)
        
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
            
            self.models = fetchedData.daily
//            self.models.removeAll()
//            self.models.append(contentsOf: result)
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
    
    func fetcharoundCities(){
        let url = generateURL(with: latitude, and: longitude,for: .cityAround)
       
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { data,response,error in
            
            guard let data = data, error == nil else{
                return
            }
            
            var cities: CityNames?
            do{
                cities = try JSONDecoder().decode(CityNames.self,from:data)
            }catch{
                print("ERRORs in Cities")
            }
            guard let fetchedData = cities else{ return }
            let dataOfCity = fetchedData.list
          
            let cityNames = dataOfCity.enumerated().map{"\($0.element.name),  \($0.element.sys.country)"}
            let cityCoordinates = dataOfCity.enumerated().map{"\($0.element.coord.lat),\($0.element.coord.lon)"}
            DispatchQueue.main.async {
                self.dropDownArray.append(contentsOf: cityNames)
              self.dropDownId.append(contentsOf: cityCoordinates)
                self.locationToday.optionArray = self.dropDownArray
                self.locationToday.optionIds = self.dropDownId
            }
            
        }).resume()
        
    }
    
    func fetchAllCountries(){
        do {
            if let bundlePath = Bundle.main.path(forResource: "countriesCoordinates",
                                                 ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                do{
                    
                      let countries = try JSONDecoder().decode(CountryCoordinates.self,from:jsonData)
                        let cityNames = countries.enumerated().map{"\($0.element.name),  \($0.element.country)"}
                        let cityCoordinates = countries.enumerated().map{"\($0.element.latitude),\($0.element.longitude)"}
                        DispatchQueue.main.async {
                            self.dropDownArray.append(contentsOf: cityNames)
                            self.dropDownId.append(contentsOf: cityCoordinates)
                        }
                }catch{
                    print("Error in countries")
                }
            }
        }catch{
            print("Error Happened")
        }
        
        
    }
    func generateURL(with lat:Double, and long: Double,for type:url)->String{
//        lat=8.699525&lon=77.516735
        switch(type){
        case .cityAround :  return "https://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(long)&cnt=50&appid=3540e704b9a91cce081155a9f4acefc6"
        case .singleCity :
            return "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely&units=metric&appid=3540e704b9a91cce081155a9f4acefc6"
        }
       
        
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
        let frameHeight = (view.frame.height * 16)/100
        return CGSize(width: frameHeight*0.667, height: frameHeight)
//        return CGSize(width: 100, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyData.count
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
