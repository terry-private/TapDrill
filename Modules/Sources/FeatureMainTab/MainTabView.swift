//
//  MainTabView.swift
//  
//
//  Created by 若江照仁 on 2023/03/12.
//

import SwiftUI

public struct MainTabView<Factory: MainTabViewFactoryProtocol>: View {
    public init() {}
    public var body: some View {
        TabView {
            Factory.selectDrillView
                .tabItem {
                    Label("ドリル", systemImage: "rectangle.grid.2x2")
                }
            Factory.settingView
                .tabItem {
                    Label("設定", systemImage: "gear")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#if DEBUG
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView<MainTabViewFactoryDummy>()
    }
}
#endif
