//
//  ThemeSettings.swift
//  Todo App
//
//  Created by Albab on 22/02/21.
//

import SwiftUI

final public class ThemeSettings: ObservableObject {
    @Published public var themeSetting: Int = UserDefaults.standard.integer(forKey: "Theme"){
        didSet{
            UserDefaults.standard.set(self.themeSetting, forKey: "Theme")
        }
    }
    private init () {}
    public static let shared = ThemeSettings()
}

