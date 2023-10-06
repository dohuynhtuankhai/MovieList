//
//  Font+Extension.swift
//  MovieList
//
//  Created by Huynh Tuan Khai Do on 19/09/2023.
//

import Foundation
import SwiftUI

public extension Font {
    enum Size: CGFloat {
        /// CGFloat: 10
        case nano = 10

        /// CGFloat: 12
        case tiny = 12

        /// CGFloat: 14
        case small = 14

        /// CGFloat: 16
        case regular = 16

        /// CGFloat: 18
        case medium = 18

        /// CGFloat: 20
        case large = 20
    }
    
    /// Font weight: 400
    static func system(size: Size) -> Font { .system(size: size.rawValue) }

    /// Font weight: 500
    static func systemMedium(size: Size) -> Font { .system(size: size.rawValue, weight: .medium) }
    
    /// Font weight: 600
    static func systemSemibold(size: Size) -> Font { .system(size: size.rawValue, weight: .semibold) }

    /// Font weight: 700
    static func systemBold(size: Size) -> Font { .system(size: size.rawValue, weight: .bold) }
}
