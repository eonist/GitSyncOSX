//test creating buttons,lists,checkbuttons,textfields, etc to the view
//NOTE: all Ui elements from apple https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIKit_Framework/index.html#classes
//Button
/**
 * multiple uibuttons and eventlistener: https://discussions.apple.com/thread/2349976?start=0&tstart=0
 */
let myButton = UIButton()
myButton.setTitle("Hai Touch Me", forState: .Normal)
myButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
myButton.frame = CGRectMake(15, 50, 300, 500)
myButton.addTarget(self, action: "pressedAction:", forControlEvents: .TouchUpInside)
self.view.addSubview( myButton)


func pressedAction(sender: UIButton!) {
   // do your stuff here 
  NSLog("you clicked on button %@", sender.tag)
}



//list for ios, may work for osx aswell: http://viperxgames.blogspot.no/2014/11/add-uitableview-programmatically-in.html