//
//  SelectLevelView.swift
//  
//
//  Created by 若江照仁 on 2023/02/22.
//

import SwiftUI
import Core
import Components

public struct SelectLevelView<Factory: SelectLevelViewFactoryProtocol>: View {
    public typealias Quiz = Factory.Quiz
    public typealias ViewModel = Factory.SelectLevelViewModel
    
    @StateObject private var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.generators)) { generator in
                    if let gameRecord = viewModel.gameRecords[generator.id] {
                        Button {
                            viewModel.selectGenerator(generator: generator)
                        } label: {
                            HStack{
                                SquareGrid(generator.previewQuiz.options) { option in
                                    option.viewType.view()
                                }
                                .frame(width: 140, height: 140)
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(generator.title)
                                        .font(.title3)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.6)
                                        .foregroundColor(.init(uiColor: .label))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Spacer()
                                    
                                    Text("条件: \(generator.requirements)")
                                        .font(.caption)
                                        .foregroundColor(.init(uiColor: .secondaryLabel))
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(gameRecord.star1 ? .yellow : .gray)
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(gameRecord.star2 ? .yellow : .gray)
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(gameRecord.star3 ? .yellow : .gray)
                                    }
                                }
                                .padding(.vertical, 20)
                                .overlay(alignment: .topTrailing) {
                                    HStack(spacing: 8) {
                                        if let time = gameRecord.time {
                                            CrownImage()
                                                .frame(width: 16, height: 12)
                                            Text("\(String(format: "%.2f", time))")
                                                .font(.caption)
                                        }
                                        
                                    }
                                    .foregroundColor(.pink)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background {
                                Color(uiColor: .tertiarySystemBackground)
                            }
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .shadow(radius: 4)
                        }
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
            Factory.voiceQuizView(
                generator: generator,
                lastRecord: viewModel.gameRecords[generator.id]! // force unwrap: タップできるならレコードがある前提,
            ) {
                viewModel.dismissGame()
            }
        }
    }
}

#if DEBUG
struct SelectLevelView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLevelView<SelectLevelViewFactoryDummy>(viewModel: .init())
    }
}
#endif
