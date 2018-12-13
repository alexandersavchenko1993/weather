//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Александр on 11/19/18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerCurrent: UIViewController {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var customCityLabel: UILabel!
    @IBOutlet weak var customTemperature: UILabel!
    @IBOutlet weak var kievTemperatureLabel: UILabel!
    @IBOutlet weak var odessaTemperatureLabel: UILabel!
    
    //CoreData!!!
    var weatherData = [WeatherData]()
    
    //Variables
    var kievTemperature:Double?
    var odessaTemperature:Double?
    
    //Адресс информации с JSON с указанным городом в SearchBar на сейчас
    let urlStringKiev = "https://api.apixu.com/v1/current.json?key=07657ea2db674a7090c94120181910&q=kiev"
    let urlStringOdessa = "https://api.apixu.com/v1/current.json?key=07657ea2db674a7090c94120181910&q=odessa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Обьявляем что VC будет являться делегатом SearchBar
        searchBar.delegate = self
        
    //Создаем background
        let background = UIImage(named: "bg.jpg")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        //Получаем данные о погоде в Киев и Одессу
        getWeatherDataToUI(urlString: urlStringKiev, temperatureLabel: kievTemperatureLabel, cityLabel: nil, isNeedName: false)
        getWeatherDataToUI(urlString: urlStringOdessa, temperatureLabel: odessaTemperatureLabel, cityLabel: nil, isNeedName: false)
    }
}

extension ViewControllerCurrent:UISearchBarDelegate{
    
    //Ивент нажатия кнопки SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Адресс информации с JSON с указанным городом в SearchBar на сейчас
        let urlStringCurrent = "https://api.apixu.com/v1/current.json?key=07657ea2db674a7090c94120181910&q=\(searchBar.text!)"
        
       //Получаем данные о погоде в кастомном городе
       getWeatherDataToUI(urlString: urlStringCurrent, temperatureLabel: customTemperature, cityLabel: customCityLabel, isNeedName: true)
    }
}

func getWeatherDataToUI(urlString:String, temperatureLabel:UILabel, cityLabel:UILabel?, isNeedName:Bool){
    
    //Переменная для хранения имени  города
    var locationCustom: String?
    //Переменная для хранения температуры в данном городе
    var temperatureCustom: Double?
    
    //Делаем GET запрос по URL погода на сейчас
    Alamofire.request(urlString).responseJSON { response in
        
        //Создаем JSON обьект для дальейшего разбора
        if let json = response.result.value {
            if let weatherDictionary = json as? [String:AnyObject] {
                
                //Получаем температуру
                if let currentWeather = weatherDictionary["current"] as? [String:AnyObject]{
                    temperatureCustom = currentWeather["temp_c"] as? Double
                }
                
                if isNeedName == true{
                //Получаем имя города
                if let currentLoction = weatherDictionary["location"] as? [String:AnyObject]{
                    locationCustom = currentLoction["name"] as? String
                    }
                }
                
                //UI должен обновлятся на главной очереди
                DispatchQueue.main.async {
                    if let temperatureCustom = temperatureCustom {temperatureLabel.text = "\(temperatureCustom)"}
                    if isNeedName == true{
                        if let locationCustom = locationCustom {cityLabel!.text = locationCustom}
                    }
                }
            }
        }
    }
}
