//
//  SelectLevelView.swift
//  
//
//  Created by 若江照仁 on 2023/02/22.
//

import SwiftUI
import Core
import Components

public struct SelectLevelView<Factory: SelectLevelViewFactoryProtocol, ViewModel: SelectLevelViewModelProtocol>: View {
    @StateObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            // TODO: 本当はLazyにするべきだが、要素が多い時に一番下から上にスクロールしている途中でなぜか落ちる。
            VStack(spacing: 16) {
                ForEach(Array(viewModel.generators)) { generator in
                    SelectLevelViewCell(
                        generator: generator,
                        star1: viewModel.gameRecords[generator.id]?.star1,
                        star2: viewModel.gameRecords[generator.id]?.star2,
                        star3: viewModel.gameRecords[generator.id]?.star3,
                        time: viewModel.gameRecords[generator.id]?.time,
                        locked: viewModel.gameRecords[generator.id] == nil
                    ) { generator in
                        viewModel.selectGenerator(generator: generator)
                    }
                }
            }
        }
        .navigationTitle(ViewModel.Quiz.title)
        .background {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()
        }
        .refreshable {
            do {
                try await viewModel.refresh()
            } catch {
                print(error)
            }
        }
        .fullScreenCover(
            item: Binding<VoiceQuizGenerator<ViewModel.Quiz>?>(
                get: { viewModel.selectedGenerator },
                set: { viewModel.selectGenerator(generator: $0) }
            ), onDismiss: {
                Task {
                    try await viewModel.refresh()
                }
            }
        ) { generator in
            if let record = viewModel.gameRecords[generator.id] {
                Factory.voiceQuizView(
                    generator: generator,
                    lastRecord: record
                ) {
                    viewModel.dismissGame()
                }
            } else {
                EmptyView()
            }
        }
    }
}

#if DEBUG
struct SelectLevelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLevelView<SelectLevelViewFactoryDummy, SelectLevelViewModelDummy>(viewModel: .init())
    }
}
#endif