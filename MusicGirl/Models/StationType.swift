//
//  StationType.swift
//  MusicGirl
//
//  Created by mio kato on 2025/07/08.
//

enum StationType: CaseIterable, Hashable, Identifiable {
    /// Classic radio channel
    case classic
    case classicPiano
    case choral
    case mozart
    case chopin
    case bach
    var id: Self { self }
}

extension StationType {
    var musicItemID: String {
        switch self {
        case .classic:
            return "ra.985486574"
        case .classicPiano:
            return "ra.1087953681"
        case .choral:
            return "ra.1325520669"
        case .mozart:
            return "ra.1286682301"
        case .chopin:
            return "ra.1578900801"
        case .bach:
            return "ra.1284711913"
        }
    }
    
    var image: String {
        switch self {
        case .classic:
            return "laketown"
        case .classicPiano:
            return "seatown"
        case .choral:
            return "sea"
        case .mozart:
            return "snow"
        case .chopin:
            return "deserttown"
        case .bach:
            return "snowtown"
        }
    }
}
