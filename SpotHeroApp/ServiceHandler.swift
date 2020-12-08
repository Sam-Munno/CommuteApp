//
//  ServiceHandler.swift
//  SpotHeroApp
//
//  Created by Sam Munno on 11/4/19.
//  Copyright © 2019 Sam Munno. All rights reserved.
//

import Foundation

public class ServiceHandler: NSObject {

//Below method calls weather API to figure out current weather of the lat and long of my apartment in chicago.
public static func getLocalWeatherReport(completion: @escaping(Bool, [String: AnyObject]) -> Void) {
    
   let urlString = "https://api.weatherbit.io/v2.0/current?lat=41.896160&lon=-87.660440&key=d645b7d39c224b37a3756ffa06963a50"
    
    let url = URL(string: urlString);
    print(url ?? "")
    var request = URLRequest(url: url!);
    request.httpMethod = "GET";
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type");
    URLSession.shared.dataTask(with: request) { data, response, error in
        if error != nil {
            completion(false, [:]);
            return;
        }
        do {
            if let resultObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                if resultObject.count != 0  {
                    if let resultArray = resultObject["data"] as? NSArray {
                        if resultArray.count > 0 {
                            if let dataObject = resultArray.object(at: 0) as? [String: AnyObject] {
                                completion(true, dataObject)
                            }
                            //If the first object of resultArray cannot be parse into a Dictionary
                            else {
                                completion(false, [:])
                            }
                        }
                        //If resultArray size is zero
                        else {
                            completion(false, [:])
                        }
                    }
                    //If the "data" array cannot be parsed
                    else {
                        completion(false, [:])
                    }
                }
                //If the resultObject size is zero
                else {
                    completion(false, [:])
                }
                
            }
            //if the data could not be parsed into a dictionary
        }catch {
            completion(false, [:]);
            return;
        }
        
        }.resume();
}
}
