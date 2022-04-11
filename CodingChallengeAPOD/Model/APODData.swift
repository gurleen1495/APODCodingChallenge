//
//  APODData.swift
//  CodingChallengeAPOD
//
//  Created by Gurleen kaur on 9/4/22.
//

import Foundation
import RealmSwift

class AstroPictureOfTheDay : Object, Decodable {
    
    @objc dynamic var media_type : String?
    @objc dynamic var date : String?
    @objc dynamic var explanation : String?
    @objc dynamic var hdurl : String?
    @objc dynamic var url : String?
    @objc dynamic var title : String?
    
    override class func primaryKey() -> String? {
        return Constants.Strings.kParamDate
    }

    private enum CodingKeys: String, CodingKey {
        case media_type
        case date
        case explanation
        case hdurl
        case url
        case title
    }

    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.media_type = try container.decodeIfPresent(String.self, forKey: .media_type)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
        self.hdurl = try container.decodeIfPresent(String.self, forKey: .hdurl)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
    }
}
