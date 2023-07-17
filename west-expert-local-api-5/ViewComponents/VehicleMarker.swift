//
//  VehicleMarker.swift
//  west-expert-local-api-5
//
//  Created by Liam Cotton on 2023-07-16.
//

import SwiftUI

struct VehicleMarker: View {
    
    let backgroundColor: Color
    let borderColor: Color
    let foregroundColor: Color
    
    
    var body: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)
                .stroke(borderColor)
                .frame(width: 20, height: 20)
                
            Image(systemName: "tram")
                .font(.system(size: 10))
                .foregroundStyle(foregroundColor)
        }
    }
    
    init?(backgroundColor: String?, borderColor: String?, foregroundColor: String?) {
        guard let bgc = Color(hex: backgroundColor),
              let fgc = Color(hex: foregroundColor) else {
            return nil
        }
        
        self.backgroundColor = bgc
        self.foregroundColor = fgc
        self.borderColor = Color(hex: borderColor) ?? bgc
    }
    
    init?(_ result: Components.Schemas.Positions_JourneyPositionApiModel) {
        guard let bgc = Color(hex: result.line?.backgroundColor),
              let fgc = Color(hex: result.line?.foregroundColor) else {
            return nil
        }
        
        self.backgroundColor = bgc
        self.foregroundColor = fgc
        self.borderColor = Color(hex: result.line?.borderColor) ?? bgc
    }
    
}

#Preview {
    VehicleMarker(backgroundColor: "#229911", borderColor: nil, foregroundColor: "#ffffff")
}
