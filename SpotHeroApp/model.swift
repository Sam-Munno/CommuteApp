//
//  model.swift
//  SpotHeroApp
//
//  Created by Sam Munno on 11/6/19.
//  Copyright © 2019 Sam Munno. All rights reserved.
//

import Foundation

class vertices {
    var visited = false
    var connections: [edges] = []
}

class edges {
    public let to: vertices
    public let weight: Int
    
    public init(to node: vertices, weight: Int) {
        assert(weight >= 0, "weight must be greater then zero")
        self.to = node
        self.weight = weight
    }
}

class Path {
    public let cumulativeWeight: Int
    public let node: vertices
    public let previousPath: Path?
    
    init(to node: vertices, via connection: edges? = nil, previousPath path: Path? = nil) {
        if
            let previousPath = path,
            let viaConnection = connection {
            self.cumulativeWeight = viaConnection.weight + previousPath.cumulativeWeight
        } else {
            self.cumulativeWeight = 0
        }
        
        self.node = node
        self.previousPath = path
    }
}

extension Path {
    var array: [vertices] {
        var array: [vertices] = [self.node]
        
        var iterativePath = self
        while let path = iterativePath.previousPath {
            array.append(path.node)
            
            iterativePath = path
        }
        
        return array
    }
}
class MyNode: vertices {
    let name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
}
func dataParserAndWeightCalculator(data: [String: AnyObject]) -> Int {
    //Goal of this function is to parse JSON and create a weight for biking in the elements. The parsing and multiplier could be segragated, but due to limited logic I combined the two functionalities and named the function clearly.
    
    //First we will parse Temperature Data And Rain Data
    var multiplier = 2
    var temperatureMultiplier: Double?
    var rainMultiplier: Int?
    
    
    if let temperature = data["temp"] as? Double {
        temperatureMultiplier = temperature
    }
    if let rain = data["precip"] as? Int {
        rainMultiplier = rain
    }
    
    //If the temp is under 4.0C or it is raining we will multiply the weight of the Biking route.
    if temperatureMultiplier != nil {
        if temperatureMultiplier! <= 4.0 {
            multiplier = multiplier * 2
        }
    }
    if rainMultiplier != nil {
        if rainMultiplier! != 0 {
            multiplier = multiplier * 3
        }
    }
    
    //Return the Multiplier
    return multiplier
}
