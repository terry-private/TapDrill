//
//  TapDrillForKidsApp.swift
//  TapDrillForKids
//
//  Created by 若江照仁 on 2023/01/10.
//

import SwiftUI
import ViewFactoryImpl
import Utility

@main
struct TapDrillForKidsApp: App {
    init() {
        SoundEffectInteractor.readyAllPlayer()
    }
    var body: some Scene {
        WindowGroup {
            AppViewFactory.mainTab()
        }
    }
}
