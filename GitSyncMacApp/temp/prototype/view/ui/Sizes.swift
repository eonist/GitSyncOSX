import Foundation
@testable import Utils

extension ProtoTypeView {
    enum WinRect {
        static let size:CGSize = CGSize(200,355)//IPhone 7: (750 x 1334) (375 x 667) ≈ (200x355)
        static let point:CGPoint = CGPoint(0,0)
    }
    enum Modal {
        static let svgSize:CGSize = CGSize(50,50)//the graphic
        static let initial:RoundedRect/*CGRect*/ = {//init modal btn size
            let size:CGSize = CGSize(100,100)
            let p:CGPoint = Grid.position(1,size)//Align.alignmentPoint(size, WinRect.size, Alignment.centerCenter, Alignment.centerCenter)
            let fillet:CGFloat = 50
            return RoundedRect(p,size,fillet)
            //return CGRect(p,size)
        }()
        static let click:RoundedRect = {//when modalBtn is pressed down
            let size:CGSize = Modal.initial.size * 0.75
            let p:CGPoint = Grid.position(1,size)//Align.alignmentPoint(size, WinRect.size, Alignment.centerCenter, Alignment.centerCenter)
            let fillet:CGFloat = Modal.initial.fillet * 0.75
            return RoundedRect(p,size,fillet)
        }()
        static let expanded:RoundedRect = {//when modal is in expanded mode
            let size = CGSize(WinRect.size.w,WinRect.size.w) - CGSize(40,0)
            let p:CGPoint = Align.alignmentPoint(size, WinRect.size, Alignment.centerCenter, Alignment.centerCenter)
            let fillet:CGFloat = 20
            return RoundedRect(p,size,fillet)
        }()
    }
    enum PromptButton {
        static let initial:CGRect = {
            let size:CGSize = CGSize(Modal.expanded.size.w,45)
            let p:CGPoint = Align.alignmentPoint(size, WinRect.size, Alignment.bottomCenter, Alignment.topCenter)
            return CGRect(p,size)
        }()
        static let expanded:CGPoint = {//the limit of where promptButton can go vertically
            return initial.origin - CGPoint(0,initial.height + 20/*<--bottom margin*/)
        }()
    }
    /**
     * Used when spacing out the buttons vertically
     */
    enum Grid{
        static let verticalSpace:CGFloat = {
            return WinRect.size.h/5//71
        }()
        static func position(_ i:Int, _ size:CGSize) -> CGPoint {
            let p = CGPoint(WinRect.size.w/2,(Grid.verticalSpace * i).rounded())
            return p - CGPoint(size.w/2,size.h/2)
        }
    }
}
