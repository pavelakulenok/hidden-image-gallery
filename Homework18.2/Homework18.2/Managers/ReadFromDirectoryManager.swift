//
//  ReadFromDirectoryManager.swift
//  Homework18.2
//
//  Created by Pavel Akulenak on 22.05.21.
//

import Foundation

enum ReadFromDirectoryManager {
    static func getImagesFolderPath() -> String {
        let imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let path = imagesFolderPath?.path else {
            return ""
        }
        return path
    }

    static func getImagesNameArray() -> [String] {
        var imagesNameArray = [String]()
        let path = getImagesFolderPath()
        do {
            imagesNameArray = try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print("Can't get content of directory")
        }
        return imagesNameArray
    }

    static func getImagePath(item: Int) -> String {
        let fileName = getImagesNameArray()[item]
        let imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let filePath = imagesFolderPath?.appendingPathComponent(fileName).path else {
            return ""
        }
        return filePath
    }
}
