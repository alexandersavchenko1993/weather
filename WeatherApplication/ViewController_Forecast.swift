//
//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Александр on 11/19/18.
//  Copyright © 2018 Александр. All rights reserved.
//

import UIKit
import Alamofire

class ViewControllerForecast: UIViewController {
    
    //Outlets
    
    
    //CoreData!!!
    var weatherData = [WeatherData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Обьявляем что VC будет являться делегатом SearchBar
        //searchBar.delegate = self
        
        //Создаем background
        let background = UIImage(named: "bg.jpg")
        self.view.backgroundColor = UIColor(patternImage: background!)
    }
}

extension ViewControllerForecast:UISearchBarDelegate{
    
    //Ивент нажатия кнопки SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //Адресс информации с JSON с указанным городом в SearchBar на три дня
        let urlStringForecast = "https://api.apixu.com/v1/forecast.json?key=07657ea2db674a7090c94120181910&q=\(searchBar.text!)&days=3"
        
        //Переменная для хранения имени кастомного города
        var locationName: String?
        //Переменная для хранения температуры кастомного города
        var temperature: Double?
        
        
        //Делаем GET запрос по URL прогноз на 3 дня
        Alamofire.request(urlStringForecast).responseJSON { response in
            
            //Создаем JSON обьект для дальейшего разбора
            if let json = response.result.value {
                if let weatherDictionary = json as? [String:AnyObject] {
                    print(weatherDictionary)
                }
            }
        }
    }
}
