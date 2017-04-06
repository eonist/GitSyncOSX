import Foundation
@testable import Utils
@testable import Element

extension Graph9 {/*Convenience*/
    typealias GraphConfig = (valueBarCount:Int,timeBarCount:Int,margin:CGSize)
    static var config:GraphConfig = (5,7,CGSize(50,50))
    var leftMargin:CGFloat {return Graph9.config.margin.width}
    var topMargin:CGFloat {return Graph9.config.margin.height}
    var valueBarCount:Int {return Graph9.config.valueBarCount}
    var timeBarCount:Int {return Graph9.config.timeBarCount}
}
