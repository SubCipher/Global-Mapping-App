

import UIKit
import MapKit
import CoreLocation


CLGeocoder().geocodeAddressString("new york, city", completionHandler: {(test,test01) in


    print(test?.count ?? 0)
    print(test01 ?? "")
})


       // Create Address String
    let country = "USA"
    let city = "NYC"
    let street = "125"
    
    let address = "\(country), \(city), \(street)"
    
    // Geocode Address String
    //geocoder.geocodeAddressString(address) { (placemarks, error) in
    CLGeocoder().geocodeAddressString(address)  { (placemarks,error) in
    // Process Response
        print("test")
        
        
}

//http://www.thomashanning.com/sorting-arrays-swift/
var dateArray = [Date]()

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MM/dd/yyyy"

dateArray.append(dateFormatter.date(from:"02/03/1985")!)
dateArray.append(dateFormatter.date(from: "12/01/2025")!)
dateArray.append(dateFormatter.date(from: "07/08/1964")!)
dateArray.append(dateFormatter.date(from: "09/04/2016")!)
dateArray.append(dateFormatter.date(from: "01/01/2000")!)
dateArray.append(dateFormatter.date(from: "12/12/1903")!)
dateArray.append(dateFormatter.date(from: "04/23/2222")!)
dateArray.append(dateFormatter.date(from: "08/06/1957")!)
dateArray.append(dateFormatter.date(from: "11/11/1911")!)
dateArray.append(dateFormatter.date(from: "02/05/1961")!)

dateArray.sort { (date1, date2) -> Bool in
    return date1.compare(date2) == ComparisonResult.orderedAscending
}

for date in dateArray {
    print(dateFormatter.string(from: date))
}


let StudentsLocationArray = [
    
    (latitude: 8.6410332000000007, mapString: " Pan ", createdAt: "2017-05-13T07:37:24.740Z", uniqueKey: 0, objectId: "73bxz7TtP4", updatedAt: "2017-05-13T07:37:24.740Z", firstName: "K", longitude: -80.405859699999993, mediaURL: "", lastName: "art12b"),
    
    (latitude: 39.714904599999997, mapString: " new castle ", createdAt: "2017-05-13T07:33:59.202Z", uniqueKey: 0, objectId: "bqgenvx2Hm", updatedAt: "2017-05-13T07:33:59.202Z", firstName: "K", longitude: -75.607273000000006, mediaURL: "", lastName: "art12a"),
    
    (latitude: 64.189134999999993, mapString: "Greenland Qaanaaq  ", createdAt: "2017-05-13T07:18:27.131Z", uniqueKey: 0, objectId: "cwDk3pZfzx", updatedAt: "2017-05-13T07:18:27.131Z", firstName: "K", longitude: -51.695592599999998, mediaURL: "http://wikitravel.org/en/Qaanaaq", lastName: "art12a"),
    
    (latitude: -37.815148999999998, mapString: " Melbourne ", createdAt: "2017-05-13T06:58:01.189Z", uniqueKey: 0, objectId: "xWGZk0q3yk", updatedAt: "2017-05-13T06:58:01.189Z", firstName: "K", longitude: 144.9664076, mediaURL: "http://wikitravel.org/en/Melbourne", lastName: "art12"),
    
    (latitude: 41.208756000000001, mapString: " Huston ", createdAt: "2017-05-13T05:44:15.293Z", uniqueKey: 0, objectId: "PZeJwIMiUC", updatedAt: "2017-05-13T05:44:15.293Z", firstName: "K", longitude: -78.574882000000002, mediaURL: "http://wikitravel.org/en/Houston", lastName: "art11c"),
    
    (latitude: 41.165308500000002, mapString: " Taba Heights ", createdAt: "2017-05-13T05:25:35.807Z", uniqueKey: 0, objectId: "1vDKAVtykG", updatedAt: "2017-05-13T05:25:35.807Z", firstName: "K", longitude: -96.038004700000002, mediaURL: "http://wikitravel.org/en/Taba_Heights", lastName: "art11b"),
    
    (latitude: 33.831589999999998, mapString: "Carson ca", createdAt: "2017-05-13T02:08:01.604Z", uniqueKey: 0, objectId: "rJ0giAahnH", updatedAt: "2017-05-13T02:08:01.604Z", firstName: "i", longitude: -118.263583, mediaURL: "https://google.com", lastName: "laaas"),
    
    
    (latitude: 33.831589999999998, mapString: "Carson ca ", createdAt: "2017-05-13T02:06:23.961Z", uniqueKey: 0, objectId: "AslIuKCHtF", updatedAt: "2017-05-13T02:06:23.961Z", firstName: "i", longitude: -118.263583, mediaURL: "https://google.com", lastName: "laaas"),
    
    (latitude: 39.728955999999997, mapString: "mapString", createdAt: "2017-05-13T02:01:49.892Z", uniqueKey: 0, objectId: "tBoAm1ShPk", updatedAt: "2017-05-13T02:01:49.892Z", firstName: "H", longitude: -121.838779, mediaURL: "www", lastName: "ddo"),
    
    (latitude: 33.767168099999999, mapString: "Long Beach ca", createdAt: "2017-05-13T01:46:33.035Z", uniqueKey: 0, objectId: "BdaEM6fsbZ", updatedAt: "2017-05-13T01:46:33.035Z", firstName: "i", longitude: -118.19372319999999, mediaURL: "https://www.bing.com", lastName: "lares"),
    
    (latitude: 35.373404999999998, mapString: "Bakersfield ca ", createdAt: "2017-05-13T01:40:18.676Z", uniqueKey: 0, objectId: "7VFU9tlnsd", updatedAt: "2017-05-13T01:40:18.676Z", firstName: "i", longitude: -119.018911, mediaURL: "https://www.google.com", lastName: "laaas"),
    
    (latitude: -37.815148999999998, mapString: " Melbourne ", createdAt: "2017-05-12T21:45:10.096Z", uniqueKey: 0, objectId: "UGAnOIXwoy", updatedAt: "2017-05-12T21:45:10.096Z", firstName: "K", longitude: 144.9664076, mediaURL: "http://www.worldcitiescultureforum.com/cities/melbourne/", lastName: "art11"),
    
    (latitude: 41.883855599999997, mapString: "USA Chicago ", createdAt: "2017-05-11T14:45:56.427Z", uniqueKey: 0, objectId: "cpWlnqbHFv", updatedAt: "2017-05-11T14:45:56.427Z", firstName: "K", longitude: -87.632350500000001, mediaURL: "http://DuckDuckGo.com", lastName: "art00"),
    
    (latitude: 41.883855599999997, mapString: " Chicago ", createdAt: "2017-05-11T14:44:49.490Z", uniqueKey: 0, objectId: "iDpspqZkOU", updatedAt: "2017-05-11T14:44:49.490Z", firstName: "K", longitude: -87.632350500000001, mediaURL: "http://DuckDuckGo.com", lastName: "art00")]
for date in StudentsLocationArray{
    

print(date.createdAt)

}
