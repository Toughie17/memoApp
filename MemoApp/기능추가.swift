//
//  기능추가.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/07.
//

import Foundation

// 사용자 커스텀 컬러
// Yes, you can create a button that allows the user to select a color in Swift by using the UIColorPickerViewController class provided by UIKit. Here's an example of how to implement this in your code:
//
//Add a button to your view controller's storyboard or programmatically.
//
//Create a UIColorPickerViewController instance in your view controller's code.
//
//swift
//Copy code
//let colorPicker = UIColorPickerViewController()
//Implement the colorPickerDidChangeSelection method to update the button's background color whenever the user selects a color.
//swift
//Copy code
//func colorPickerDidChangeSelection(_ picker: UIColorPickerViewController) {
//    yourButton.backgroundColor = picker.selectedColor
//}
//Add an action to the button that displays the UIColorPickerViewController when tapped.
//swift
//Copy code
//@IBAction func showColorPicker(_ sender: UIButton) {
//    present(colorPicker, animated: true, completion: nil)
//}
//Connect the button's action to the showColorPicker method in your view controller.
//Now, when the user taps the button, the UIColorPickerViewController will be displayed, allowing them to select a color. Whenever they select a color, the colorPickerDidChangeSelection method will be called, which updates the button's background color to the selected color.
//
//Note that the UIColorPickerViewController is only available on devices running iOS 14 or later. If you need to support earlier versions of iOS, you may need to use a different approach for allowing the user to select a color.

//움직이는 스플래시 스크린
//https://asxpyn.tistory.com/74
