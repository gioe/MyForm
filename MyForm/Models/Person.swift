//
//  Person.swift
//  MyForm
//
//  Created by Matt Gioe on 1/25/18.
//  Copyright © 2018 Trevor Beasty. All rights reserved.
//

import Foundation

struct Person: Codable {
    
    enum PersonCodingKeys: CodingKey {
        case name
        case age
    }
    
    var name: String
    var age: Int
    
    static let codingKeys: [CodingKey] = [PersonCodingKeys.name, PersonCodingKeys.age]
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PersonCodingKeys.self)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encodeIfPresent(age, forKey: .age)
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PersonCodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        age = try values.decodeIfPresent(Int.self, forKey: .age) ?? 10
    }
}
