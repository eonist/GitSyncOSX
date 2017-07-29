import Cocoa
@testable import Utils
@testable import Element

class ProtoTypeView:WindowView{
    lazy var section:Section = {//background
        StyleManager.addStyle("#bg{fill:white;padding-top:24px;}")
        return self.addSubView(Section(WinRect.size.w,WinRect.size.h,self,"bg"))
    }()
    lazy var modalBtn:Button = {//button
        StyleManager.addStyle("Button#modalBtn{width:\(Modal.initial.size.w)px;height:\(Modal.initial.size.h)px;fill:blue;corner-radius:20px;clear:none;float:none;}")
        let btn = self.addSubView(ForceTouchButton(Modal.initial.size.w,Modal.initial.size.h,nil,"modalBtn"))
        btn.point = Modal.initial.origin//center button
        return btn
    }()
    
    lazy var style:Style = self.modalBtn.skin!.style! as! Style
    
    
    lazy var modalAnimator = ElasticEaser5(CGRect.defaults, DefaultEasing.rect,Constraint.content,Constraint.mask) { (rect:CGRect) in
        //anim rect here buttonRect to modalRect
        //Swift.print("rect: " + "\(rect)")
        disableAnim {
            StyleModifier.overrideStylePropVal(&self.style, ("width",0), rect.size.w)
            StyleModifier.overrideStylePropVal(&self.style, ("height",0), rect.size.h)
            self.modalBtn.skin?.setStyle(self.style)
            self.modalBtn.layer?.position = rect.origin
        }
    }
    
    override func resolveSkin(){
        Swift.print("ProtoTypeView.resolveSkin()")
        
        super.resolveSkin()
        _ = section
        
        
    
        
        
        modalAnimator.value = Modal.initial
        
        /**
         * PromptBtn
         */
        
        
        let promptBtn:Button = {//button
            var css:String = ""
            css += "Button#prompt{width:\(PromptButton.initial.size.w)px;height:\(PromptButton.initial.size.h);fill:purple;corner-radius:20px;clear:none;float:none;}"
            css += "Button#prompt:down{fill:grey;}"
            
            StyleManager.addStyle(css)
            
            let btn = self.addSubView(Button(Modal.initial.w,Modal.initial.h,nil,"prompt"))
            btn.layer?.position = PromptButton.initial.origin//out of view
            return btn
        }()
        
        let promptBtnAnimator = Easer5<CGPoint>.init(CGPoint.defaults, DefaultEasing.point){ point in
            disableAnim {
                promptBtn.layer?.position = point
            }
        }
        promptBtnAnimator.value = PromptButton.initial.origin//set initial value
       
        /**
         * Event handling:
         */
        
//      var forceTouchMode:Int = 0//which level of forceTouch modal is currently in
        var modalStayMode:Bool = false//you can probably remove this and replace it with boundry check etc
        var leftMouseDraggedMonitor:Any?
        //var leftDraggedHandler:NSEventHandler?
        var onMouseDownMouseY:CGFloat = CGFloat.nan
        
//      var prevStage:Int = 0
        
        
        
        let forceTouchHandler = { (_ event:ForceTouchEvent) in
            //Swift.print("event.type: " + "\(event.type)")
            if event.type == ForceTouchEvent.clickDown{
                Swift.print("clickDown")
                modalAnimator.setTargetValue(Modal.click).start()
            }else if event.type == ForceTouchEvent.deepClickDown{
                Swift.print("deepClickDown")
                modalAnimator.setTargetValue(Modal.expanded).start()//Swift.print("window.contentView.localPos(): " + "\(window.contentView!.localPos())")
                onMouseDownMouseY  = self.window!.contentView!.localPos().y
                NSEvent.addMonitor(&leftMouseDraggedMonitor,.leftMouseDragged){_ in
                    let relativePos:CGFloat =  onMouseDownMouseY - self.window!.contentView!.localPos().y
                    //Swift.print("relativePos: " + "\(relativePos)")
                    var newRect = Modal.expanded
                    newRect.y -= relativePos
                    modalAnimator.direct = true
                    modalAnimator.setTargetValue(newRect).start()
                    if modalAnimator.value.y < 30  {//modal in stayMode
                        modalStayMode = true
                        Swift.print("reveal buttons: \(modalAnimator.value.y)")
                        var p = modalAnimator.value.bottomLeft
                        p.y += 15//add some margin
                        p.y = p.y.max(PromptButton.expanded.y)
                        //
                        promptBtnAnimator.setTargetValue(p).start()//you could do modalBtn.layer.origin + getHeight etc.
                    }else if modalAnimator.value.y > 30 {//modal in leaveMode
                        modalStayMode = false
                        Swift.print("anim buttons out")
                        promptBtnAnimator.setTargetValue(PromptButton.initial.origin).start() //anim bellow screen
                    }
                }
            }else if event.type == ForceTouchEvent.clickUp {
                Swift.print("clickUp")
                if !modalStayMode {//modal stay
                    modalAnimator.setTargetValue(Modal.initial).start()
                }
                
            }else if event.type == ForceTouchEvent.deepClickUp {
                Swift.print("deepClickUp")
                if modalStayMode {//modal stay
                    Swift.print("modal stay")
                    self.modalBtn.removeHandler()
                    modalAnimator.direct = false
                    var rect = Modal.expanded
                    rect.origin.y -= 30
                    modalAnimator.setTargetValue(rect).start()
                }else{//modal leave
                    Swift.print("modal leave")
                    modalAnimator.direct = false
                    modalAnimator.setTargetValue(Modal.initial).start()

                    /*promptBtn*/
                    promptBtnAnimator.setTargetValue(PromptButton.initial.origin).start() //anim bellow screen
                }
                NSEvent.removeMonitor(&leftMouseDraggedMonitor)
            }
            if event.type == ForceTouchEvent.stageChange {
                let stage:Int = event.stage
                Swift.print("stage: " + "\(stage)")
                if stage == 0 {
                    if !modalStayMode {
                        StyleModifier.overrideStylePropVal(&style, ("fill",0), NSColor.blue)
                        Swift.print("override to blue")
                    }
                }else if stage == 1{
                    if !modalStayMode && event.prevStage == 0{ //only change to red if prev stage was 0
                        StyleModifier.overrideStylePropVal(&style, ("fill",0), NSColor.red)
                        Swift.print("override to red")
                    }
                    
                }else /*if stage == 2*/{
                    if !modalStayMode {
                        StyleModifier.overrideStylePropVal(&style, ("fill",0), NSColor.green)
                        Swift.print("override to green")
                    }
                    
                }
                //prevStage = stage
            }
            
            disableAnim {
                self.modalBtn.skin?.setStyle(style)
            }
        }
        
        modalBtn.addHandler(forceTouchHandler)
        
        /*handler for promptBtn*/
        promptBtn.addHandler(type:ButtonEvent.upInside) { (event:ButtonEvent) in
            Swift.print("promptBtn.upInside")
            modalAnimator.setTargetValue(Modal.initial).start()/*outro modal*/
            promptBtnAnimator.setTargetValue(PromptButton.initial.origin).start()/*outro promptBtn*/
            self.modalBtn.addHandler(forceTouchHandler)//reAdded forcetoucheventhandler, ideally add this handler on outro complete
            modalStayMode = false
        }
        
        
        //1. Add some design elements (the goal today is to refactor, then add the design to the anim and make a gif with iphone template, and launch Animator, ElementiOS and update ElementMacOS, and write article aout prototyping with swift and playground)
            //create other concepts in illustrator
            //get device templates
            //svg?
            //setup proper TestView with class scoped var's etc 👈
                //Make design for demo2. stack of cards you can shuffle left and right etc (AppleWatch)
                //make design for demo3. basically just swipe left right cards and click to go to fullscreen (AppleTV)
                //make Element extension that implements Animatable. Which lets you change: size,pos,color ⚠️️
                // I think you can extract the Constrainer for the animator into a static class instead of extending 👈
    }
    
    
}
