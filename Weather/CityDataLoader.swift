// Loading Json Data
// @Aswin Sampath

import Foundation
import SwiftyJSON

public class CityDataLoader{
    
    @Published var cityData = [CityAttributes]()
    
    init(){
        loadData()
    }
    
    func loadData(){
        if let cityListJsonFile =  Bundle.main.url(forResource: "city", withExtension: "json"){
            //do catch in case of an error
            do{
                let data = try Data(contentsOf: cityListJsonFile)
                let jsonDecoder = JSONDecoder()
                let cityData = try jsonDecoder.decode([CityAttributes].self, from: data)
                
                self.cityData = cityData     
                
            }catch{
                print(error)
            }
        }
        self.cityData = self.cityData.sorted(by: {$0.name > $1.name})
    }
}
