//
//  Student.swift
//  DynamicKeys
//
//  Created by Talib on 16/09/22.
//

import Foundation


struct DecodedArray: Decodable {

    // ***
    // Define typealias required for Collection protocl conformance
    typealias DecodedArrayType = [Student]

    // ***
    var array: DecodedArrayType

    // Define DynamicCodingKeys type needed for creating decoding container from JSONDecoder
    private struct DynamicCodingKeys: CodingKey {

        // Use for string-keyed dictionary
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }

    init(from decoder: Decoder) throws {

        // Create decoding container using DynamicCodingKeys
        // The container will contain all the JSON first level key
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        // ***
        var tempArray = DecodedArrayType()

        // Loop through each keys in container
        for key in container.allKeys {

            // Decode Student using key & keep decoded Student object in tempArray
            let decodedObject = try container.decode(Student.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }

        // Finish decoding all Student objects. Thus assign tempArray to array.
        array = tempArray
    }
}

struct Student: Decodable {

    let firstName: String
    let lastName: String

    // 1
    // Define student ID
    let studentId: String

    // 2
    // Define coding key for decoding use
    enum CodingKeys: CodingKey {
        case firstName
        case lastName
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        // 3
        // Decode firstName & lastName
        firstName = try container.decode(String.self, forKey: CodingKeys.firstName)
        lastName = try container.decode(String.self, forKey: CodingKeys.lastName)

        // 4
        // Extract studentId from coding path
        studentId = container.codingPath.first!.stringValue
    }
}


extension DecodedArray: Collection {

    // Required nested types, that tell Swift what our collection contains
    typealias Index = DecodedArrayType.Index
    typealias Element = DecodedArrayType.Element

    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { return array.startIndex }
    var endIndex: Index { return array.endIndex }

    // Required subscript, based on a dictionary index
    subscript(index: Index) -> Iterator.Element {
        get { return array[index] }
    }

    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return array.index(after: i)
    }
}
