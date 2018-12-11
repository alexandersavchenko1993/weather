//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Александр on 11/19/18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var CityLabel: UILabel!
    @IBOutlet weak var TemperatureLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //Обьявляем что VC будет являться делегатом SearchBar
        searchBar.delegate = self
    }
}

extension ViewController:UISearchBarDelegate{
    
    //Ивент нажатия кнопки SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Адресс информации с JSON с указанным городом в SearchBar
        let urlString = "https://api.apixu.com/v1/current.json?key=07657ea2db674a7090c94120181910&q=\(searchBar.text!)"
        
        //Переменная для хранения имени города
        var locationName: String?
        //Переменная для хранения температуры в данном городе
        var temperature: Double?

        //Делаем GET запрос по URL
        Alamofire.request(urlString).responseJSON { response in
            
        //Создаем JSON обьект для дальейшего разбора
            if let json = response.result.value {
                if let weatherDictionary = json as? [String:AnyObject] {
                   
                    //Получаем температуру
                    if let currentWeather = weatherDictionary["current"] as? [String:AnyObject]{
                        temperature = currentWeather["temp_c"] as? Double
                    }
                    
                    //Получаем имя города
                    if let currentLoction = weatherDictionary["location"] as? [String:AnyObject]{
                        locationName = currentLoction["name"] as? String
                    }
                    
                    //UI должен обновлятся на главной очереди
                    DispatchQueue.main.async {
                        if let locationName = locationName {self.CityLabel.text = locationName}
                        if let temperature = temperature {self.TemperatureLabel.text = "\(temperature)"}
                    }
                }
            }
        }
    }
}

