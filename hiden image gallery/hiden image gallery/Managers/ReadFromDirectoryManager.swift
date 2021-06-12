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
            assertionFailure("can't get images folder path")
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
            assertionFailure("can't read files from \(path)")
        }
        return imagesNameArray
    }

    static func getImagePath(item: Int) -> String {
        let fileName = getImagesNameArray()[item]
        let imagesFolderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        guard let filePath = imagesFolderPath?.appendingPathComponent(fileName).path else {
            assertionFailure("can't get image path")
            return ""
        }
        return filePath
    }
}
