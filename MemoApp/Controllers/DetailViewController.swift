//
//  DetailViewController.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    //버튼 하나하나 설정하기 보다는, 배열로 만들어 쉽게 관리 (고차함수 활용 가능)
    lazy var buttons: [UIButton] = {
        return [redButton, greenButton, blueButton, purpleButton]
    }()
    
    @IBOutlet weak var mainTextView: UITextView!
    @IBOutlet weak var basicView: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let memoManager = CoreDataManager.shared
    
    var memoData: MemoData? {
        didSet {
            temporaryColorNum = memoData?.color
        }
    }
    
    //버튼을 누를 때마다 컬러가 변경 되는데, 이를 위한 임시 숫자
    var temporaryColorNum: Int64? = 3
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        configureUI()
    }
    
    func setup() {
        mainTextView.delegate = self
        
        basicView.clipsToBounds = true
        basicView.layer.cornerRadius = 10
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        //버튼 색깔 초기화
        clearButtonColors()
    }
    
    //기존 데이터의 여부에 따라 UI 세팅하기
    func configureUI() {
        //기존 데이터가 있을 때
        //네비바의 타이틀 변경, 버튼 타이틀 변경, 키보드 자동 팝업
        if let memoData = self.memoData {
            self.title = "Edit Memo"
            
            guard let text = memoData.memoText else { return }
            mainTextView.text = text
            
            mainTextView.textColor = .black
            saveButton.setTitle("Update", for: .normal)
            mainTextView.becomeFirstResponder() //키보드 슉
            let color = MyColor(rawValue: memoData.color)
            setupColorTheme(color: color)
            
        } else {
            //데이터가 없는 경우
            self.title = "New Memo"
            
            mainTextView.text = "텍스트를 입력하세요"
            mainTextView.textColor = .lightGray
            saveButton.setTitle("Save", for: .normal)
            setupColorTheme(color: .blue)
        }
        setupColorButton(num: temporaryColorNum ?? 3)
        
    }
    
    //버튼의 모서리를 둥글게 깎기 위해 정확한 시점은 viewDidLayoutSubviews (드로잉 사이클 참고)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        buttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }
    
    
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        // 임시숫자 저장
        self.temporaryColorNum = Int64(sender.tag)
        let color = MyColor(rawValue: Int64(sender.tag))
        setupColorTheme(color: color)
        
        clearButtonColors()
        setupColorButton(num: Int64(sender.tag))
        
    }
    
    func setupColorTheme(color: MyColor? = .blue) {
        basicView.backgroundColor = color?.backgroundColor
        saveButton.backgroundColor = color?.buttonColor
    }
    
    
    func setupColorButton(num: Int64) {
        switch num {
        case 1:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        case 2:
            greenButton.backgroundColor = MyColor.green.buttonColor
            greenButton.setTitleColor(.white, for: .normal)
        case 3:
            blueButton.backgroundColor = MyColor.blue.buttonColor
            blueButton.setTitleColor(.white, for: .normal)
        case 4:
            purpleButton.backgroundColor = MyColor.purple.buttonColor
            purpleButton.setTitleColor(.white, for: .normal)
        default:
            blueButton.backgroundColor = MyColor.blue.buttonColor
            blueButton.setTitleColor(.white, for: .normal)
        }
    }
    
    func clearButtonColors() {
        redButton.backgroundColor = MyColor.red.backgroundColor
        redButton.setTitleColor(MyColor.red.buttonColor, for: .normal)
        greenButton.backgroundColor = MyColor.green.backgroundColor
        greenButton.setTitleColor(MyColor.green.buttonColor, for: .normal)
        blueButton.backgroundColor = MyColor.blue.backgroundColor
        blueButton.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        purpleButton.backgroundColor = MyColor.purple.backgroundColor
        purpleButton.setTitleColor(MyColor.purple.buttonColor, for: .normal)
    }
    
        let updateAlertController = UIAlertController(title: "메모가 업데이트 되었어요 :)", message: nil, preferredStyle: .alert)
        let saveAlertController = UIAlertController(title: "메모를 저장했어요 :)", message: nil, preferredStyle: .alert)
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("버튼이 눌렸습니다")
        
        if let memoData = self.memoData {
            memoData.memoText = mainTextView.text
            memoData.color = temporaryColorNum ?? 3
            memoManager.updateMemo(newMemoData: memoData) {
                print("업데이트 완료")
//                self.present(self.updateAlertController, animated: true, completion: nil)
//                 let delay = 1.0 // In seconds
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
//                    self.updateAlertController.dismiss(animated: true, completion: nil)
//                }
                    self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            print("저장 완료")
            let memoText = mainTextView.text
            memoManager.saveMemoData(memoText: memoText, colorInt: temporaryColorNum ?? 3) {
                print("저장 완료")
//                self.present(self.saveAlertController, animated: true, completion: nil)
//                 let delay = 1.0 // In seconds
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
//                    self.saveAlertController.dismiss(animated: true, completion: nil)
//                }
                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    

    
    
    //    @IBAction func saveButtonTapped(_ sender: UIButton) {
    //        if let memoData = self.memoData {
    //
    //            memoData.memoText = mainTextView.text
    //            memoData.colorInt = temporaryColorNum ?? 3
    //            memoManager.updateMemo(newMemoData: memoData) {
    //                print("hi")
    ////                self.present(self.updateAlertController, animated: true, completion: nil)
    ////                let delay = 1.0 // In seconds
    ////                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
    ////                self.updateAlertController.dismiss(animated: true, completion: nil)
    ////                }
    //                self.navigationController?.popViewController(animated: true)
    //            }
    //
    //        } else {
    //            let memoText = mainTextView.text
    //            memoManager.saveMemoData(memoText: memoText, colorInt: temporaryColorNum ?? 3) {
    ////                self.present(self.saveAlertController, animated: true, completion: nil)
    ////                let delay = 1.0 // In seconds
    ////                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
    ////                    self.saveAlertController.dismiss(animated: true, completion: nil)
    ////                }
    //                print("hi")
    //                self.navigationController?.popViewController(animated: true)
    //            }
    //        }
    //    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension DetailViewController: UITextViewDelegate {
    //텍스트뷰에는 플레이스홀더(어떻게 작성하는지 유저에게 알려주는)가 없기 때문에, 해당 기능처럼 활용하기 위함
    //텍스트뷰에서 키보드가 올라오고 입력을 시작 했을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 입력하세요" {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    //터치 한번 했다가 아무것도 입력하지 않으면 placeholder를 다시 띄우기 위한 코드
    // 공백만 입력한 경우도 뜨게!
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //공백과 줄바꿈을 전부 제거한 텍스트가 비어있을 경우
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 입력하세요"
            textView.textColor = .lightGray
        }
    }
}
