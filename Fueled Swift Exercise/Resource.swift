//
//  Resource.swift
//  Fueled Swift Exercise
//
//  Created by Kriti  Agarwal on 28/12/21.
//

import Foundation

public enum Resource: String {

    case Users
    case Posts
    case Comments

    public func data() -> Data {
        let path = Bundle.main.path(forResource: self.rawValue, ofType: "json")!
        return FileManager.default.contents(atPath: path)!
    }

}

