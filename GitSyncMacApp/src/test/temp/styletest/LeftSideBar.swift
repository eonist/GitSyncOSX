import Foundation
@testable import Utils
@testable import Element

class LeftSideBar:Element{
    var selectGroup:SelectGroup?
    override func resolveSkin() {
        var css:String = ""
        css += "#leftBar{fill:orange;fill-alpha:0;width:80px;height:100%;float:left;padding-top:26px;}"
        css += "#buttonSection {"
        css +=     "width:100%;"
        css +=     "height:100%;"
        css +=     "padding-top:16px;"
        css +=     "padding-left:28px;"
        css += "}"
        css += "#buttonSection SelectButton{"
        css +=     "fill:green;"
        css +=     "fill-alpha:0.3;"
        css +=     "width:24;"
        css +=     "height:24;"
        css +=     "float:left;"
        css +=     "clear:left;"
        css +=     "margin-bottom:12px;"
        css += "}"
        css += "#buttonSection SelectButton:selected{"
        css +=      "fill-alpha:0.6;"
        css += "}"
        StyleManager.addStyle(css)
        super.resolveSkin()
        createButtons()
    }
    func createButtons(){
        let buttonSection = self.addSubView(Section(NaN,NaN,self,"buttonSection"))
        let titles = [Views2.Main.commit.rawValue,Views2.Main.repo.rawValue,Views2.Main.prefs.rawValue]
        var buttons:[ISelectable] = titles.map{ buttonTitle in
            return buttonSection.addSubView(SelectButton(20,20,true,buttonSection,buttonTitle))
        }
        selectGroup = SelectGroup(buttons,buttons[0])
        func onSelect(event:Event){
            if event.type == SelectEvent.select {
                if let btn:SelectButton = event.origin as? SelectButton{
                    Swift.print("btn.id: " + "\(btn.id)")
                }
            }
        }
        selectGroup!.event = onSelectGroupChange
        //selectGroup.event = onSelect
    }
    

    func onSelectGroupChange(event:Event){
        if(event === (SelectGroupEvent.change,selectGroup!)){
            let buttonId:String = (selectGroup!.selected as! Element).id!
            Swift.print("LeftBarMenu.onSelect() buttonId: " + "\(buttonId)")
            let type:Views2.Main = Views2.Main(rawValue:buttonId)!//<--nice!
            Nav.setView(Views2.main(type))//👌
        }
    }
}