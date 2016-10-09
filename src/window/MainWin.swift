import Foundation

class MainWin:Window {
    required init(_ docWidth:CGFloat,_ docHeight:CGFloat){
        super.init(docWidth, docHeight)
        WinModifier.align(self, Alignment.centerCenter, Alignment.centerCenter,CGPoint(6,0))/*aligns the window to the screen*/
    }
    override func resolveSkin() {
        super.resolveSkin()
        //      Swift.print("frame.width: " + "\(frame.width)")
        //      Swift.print("frame.height: " + "\(frame.height)")
        self.contentView = MainView(frame.width,frame.height)/*Sets the mainview of the window*/
    }
    required init?(coder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}