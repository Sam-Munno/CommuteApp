//
//  ViewController.swift
//  SpotHeroApp
//
//  Created by Sam Munno on 11/4/19.
//  Copyright © 2019 Sam Munno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let commuteImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()


    }
    
     //MARK: - Load UI
    func loadUI(){
        let goodMorningLabel = UILabel(frame:CGRect(x: 10, y: 10, width: view.frame.width - 20, height: view.frame.height/6))
        goodMorningLabel.textColor = UIColor.black
        goodMorningLabel.text = "Good Morning Sam!"
        goodMorningLabel.textAlignment = .center
        goodMorningLabel.font = UIFont.systemFont(ofSize: 35)
        goodMorningLabel.backgroundColor = UIColor.clear
        view.addSubview(goodMorningLabel)
        
        let goodMorningImage = UIImageView(frame: CGRect(x: 0, y: goodMorningLabel.frame.maxY, width: view.frame.width, height: view.frame.height/3))
        goodMorningImage.backgroundColor = UIColor.clear
        goodMorningImage.image = #imageLiteral(resourceName: "sun")
        
        view.addSubview(goodMorningImage)
        
        let commuteButton = UIButton(type: .custom)
        commuteButton.setTitle("How should I commute today?", for: .normal)
        commuteButton.isEnabled = true
        commuteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        commuteButton.frame = CGRect(x: 20 , y: goodMorningImage.frame.maxY , width: view.frame.width - 40, height: 60)
        commuteButton.layer.borderWidth = 2.0
        commuteButton.layer.borderColor = UIColor.white.cgColor
        commuteButton.layer.cornerRadius = 6.0
        commuteButton.addTarget(self, action:#selector(serviceCallForWeatherData),for: .touchUpInside)
        commuteButton.backgroundColor = UIColor.clear
        view.addSubview(commuteButton);
        
        commuteImageView.frame = CGRect(x: 60, y: commuteButton.frame.maxY + 20, width: view.frame.width - 120, height: view.frame.height/4)
        commuteImageView.backgroundColor = UIColor.clear
       
        view.addSubview(commuteImageView)
    }
    
     //MARK: - Service Call For Weather Data
    @objc func serviceCallForWeatherData() {
        ServiceHandler.getLocalWeatherReport(completion: { (succeeded, data) in
            if succeeded {
                print("heck ya, the service call worked")
                //Here we parse the Data from the weather service and return the BikingWeight based on weather conditions
                let weatherMultiplier = dataParserAndWeightCalculator(data: data)
                self.setupGraphToFindShortestPath(weatherMultiplier: weatherMultiplier)
            }
            else {
                //service call failed
                self.displayTransportMethod(image: #imageLiteral(resourceName: "notfound"))
            }
        })
    }
    
     //MARK: - Create Graph to use Dijsktra's Algorithm to determine the best route to work today
    func setupGraphToFindShortestPath(weatherMultiplier: Int) {
        let home = MyNode(name: "Home")
        let bike = MyNode(name: "Biking")
        let train = MyNode(name: "Train")
        let car = MyNode(name: "Drive")
        let parking = MyNode(name: "Parking")
        let office = MyNode(name: "Office")
       
        
        //This vertex signifies My house to my Bike
        home.connections.append(edges(to: bike, weight: 2))
        //This vertex signifies My house to the Train
        home.connections.append(edges(to: train, weight: 3))
        //This vertex signifies My house to my Car
        home.connections.append(edges(to: car, weight: 1))
        //This vertex signifies biking to the office
        bike.connections.append(edges(to: office, weight: weatherMultiplier))
        //This vertex signifies taking the train to the office
        train.connections.append(edges(to: office, weight: 2))
        //This vertex signifies driving to a parking spot
        car.connections.append(edges(to: parking, weight: 1))
        //This signifies finding parking and the walking to the office
        parking.connections.append(edges(to: office, weight: 5))
        //This signifies parking with SpotHero and walking to the office
        //Uncomment Below line to Park with SpotHero
       // parking.connections.append(edges(to: office, weight: 1))
        
        let sourceNode = home
        let destinationNode = office
        
        var path = shortestPathFinder(source: sourceNode, destination: destinationNode)
        
        if let succession: [String] = path?.array.reversed().compactMap({ $0 as? MyNode}).map({$0.name}) {
            if succession.contains("Biking") {
                displayTransportMethod(image: #imageLiteral(resourceName: "Bike"))
            }
            else if succession.contains("Drive") {
                displayTransportMethod(image: #imageLiteral(resourceName: "Car"))
            }
            else if succession.contains("Train") {
                displayTransportMethod(image: #imageLiteral(resourceName: "Train"))
            }
            else {
                displayTransportMethod(image: #imageLiteral(resourceName: "notfound"))
            }
        } else {
            displayTransportMethod(image: #imageLiteral(resourceName: "notfound"))
        }
    }
      //MARK: - Display Transport method image
   func displayTransportMethod(image: UIImage) {
     DispatchQueue.main.async{
        self.commuteImageView.image = image
        }
    }


}

