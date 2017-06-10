import Cocoa
@testable import Utils
@testable import Element
@testable import GitSyncMac
/**
 * 
 */


//XML

    //cur3dIdx:[Int] = [0]
    //prev3dIdx:[Int]? = nil

    //getItemsAt3dIdx

    //on list click
        //find 2dIDX
        //append to cur3dIDX
        //getItemsAt3dIdx
        //add items to list

    //on backBtn click
        //remove the last item in curidx3d
        //getItemsAt3dIDX
        //addItemsToList




class RepoView2:Element {
    lazy var buttonSection:Section = {
        return self.addSubView(Section(NaN,NaN,self,"buttonSection"))
    }()
    lazy var backBtn:TextButton = {
        return self.buttonSection.addSubView(TextButton(NaN,NaN,"Back",self.buttonSection,"back"))
    }()
    override func resolveSkin() {
        super.resolveSkin()//self.skin = SkinResolver.skin(self)//
        _ = backBtn
        
        
        _ = self.addSubView(Element(NaN, NaN, self, "ruler"))
        
        let xml = FileParser.xml("~/Desktop/assets/xml/list.xml".tildePath)
        let dp:DataProvider = DataProvider(xml)
        let list:ElasticSlideScrollFastList3 = self.addSubView(ElasticSlideScrollFastList3.init(getWidth(), getHeight(), CGSize(24,32), dp, self, "", .ver))
        list.selectAt(1)
    }
    override func onEvent(_ event: Event) {
        if event.type == ButtonEvent.upInside && event.origin === backBtn {
            Swift.print("back")
        }else if event.type == ListEvent.select {
            Swift.print("list event")
            if let idx:Int = (event as? ListEvent)?.index {
                Swift.print("idx: " + "\(idx)")
            }
        }
    }
    override func getClassType() -> String {
        return "\(RepoView.self)"
    }
}