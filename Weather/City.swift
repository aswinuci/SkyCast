// City Structure
// @Aswin Sampath

import Foundation

struct CityAttributes: Codable {
    
    var id: Int
    var name: String
    var state: String
    var country: String
    var coord: CityCoordinates
}

struct CityCoordinates: Codable{
    var lat: Double
    var lon: Double
}
