import Cocoa
@testable import Utils
@testable import Element
/**
 * TODO: Maybe make mainView into a lazy static prop similar to RepoView
 */
class StyleTestView:CustomView{
<<<<<<< HEAD
=======
//    static let shared:StyleTestView = {
//        let frame = PrefsView.prefs.rect
//        Swift.print("StyleTestView.frame: " + "\(frame)")
//        return StyleTestView(frame.size.width,frame.size.height)/*⬅️️🚪*/
//    }()
>>>>>>> origin/master
    lazy var main:Section = {
        return self.addSubView(Section(NaN,NaN,self,"main"))
    }()
    lazy var content:Section = {
        return self.main.addSubView(Section(NaN,NaN,self.main,"content"))
    }()
    lazy var leftBar:LeftSideBar = {
        return self.main.addSubView(LeftSideBar(NaN,NaN,self.main,"leftBar"))
    }()
    var currentView:Element?//attached to content
    var currentPrompt:Element?//attached to content
    override func resolveSkin(){
        super.resolveSkin()
        _ = main
        Swift.print("resolve a")
        _ = leftBar
        Swift.print("resolve b")
        _ = content
<<<<<<< HEAD
=======
        Swift.print("resolve complete")
>>>>>>> origin/master
    }
    /**
     * NOTE: gets calls from Window.didResize
     */
    override func setSize(_ width:CGFloat,_ height:CGFloat){
        super.setSize(width, height)
        //Swift.print("StyleTestView.setSize w:\(width) h:\(height)")
        ElementModifier.refreshSize(self.main)
    }
    /**
     * 1. make StyleTestWin have a static view 👈
     * 2. make then you can make this method a non-static one and use regular optionals
     * 3. Then continue making the hide sidebar when dialog etc
     */
    func toggleSideBar(hide:Bool){
        Swift.print("toggleSideBar: hide: " + "\(hide)")
        //remove leftSideBar
        let mainView:StyleTestView = self
        let iconSection = mainView.iconSection
        if hide {
            iconSection.setSkinState("hidden")/*hides the Min,Max,Close btns*/
            leftBar.setSkinState("hidden")
            content.setSkinState("full")
        }else{
            iconSection.setSkinState("")/*default*/
            leftBar.setSkinState("")/*default*/
            content.setSkinState("")/*default*/
        }
        ElementModifier.refreshSkin(leftBar)
        ElementModifier.refreshSkin(content)
        /*detailView.setSkinState(detailView.getSkinState())*/
        ElementModifier.float(leftBar)
        ElementModifier.float(content)/**/
        //self.setSize(getWidth(),getHeight())
        Swift.print("toggle completed")
    }
}
