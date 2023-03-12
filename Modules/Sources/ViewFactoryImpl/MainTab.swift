//
//  File.swift
//  
//
//  Created by 若江照仁 on 2023/03/12.
//

import SwiftUI
import Drills
import Extensions
import FeatureMainTab
import FeatureSelectDrill

public enum MainTabViewFactoryImpl: MainTabViewFactoryProtocol {
    @MainActor
    public static var selectDrillView: AnyView {
        NavigationStack {
            SelectDrillView<SelectDrillViewFactoryImpl, SelectDrillViewModelImpl>(
                viewModel: .init(
                    selectors: [
                        ShapeDrillLevelSelector.basic1,
                        ColorDrillLevelSelector.basic1,
                        FunnyAnimalDrillLevelSelector.basic1,
                        CreatureDrillLevelSelector.advanced1,
                        FruitsAndVegetablesDrillLevelSelector.fruit1,
                        VehicleDrillLevelSelector.basic1,
                        NumberDrillLevelSelector.dice123,
                        HiraganaDrillLevelSelector.あ行
                    ]
                )
            )
        }
        .toAnyView()
    }
    
    @MainActor
    public static var settingView: AnyView {
        Text("設定")
            .toAnyView()
    }
}

