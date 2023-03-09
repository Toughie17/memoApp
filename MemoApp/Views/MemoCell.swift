//
//  MemoCell.swift
//  MemoApp
//
//  Created by KimChoonSik on 2023/03/06.
//

import UIKit

final class MemoCell: UITableViewCell {

    
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var memoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    //memoData를 전달 받을 변수(전달 받은 후 -> 표시하는 메서드 실행)
    //didSet을 활용해 데이터가 변경될 때마다 update 되는 방식
    var memoData: MemoData? {
        didSet {
            configurationUIwithData()
        }
    }
    
    //델리게이트 패턴 대신 실행하고 싶은 클로저 저장
    //뷰컨트롤러에서 클로저를 받아옴(셀 자신을 전달)
    
    var updateButtonPressed: (MemoCell) -> Void = { (sender) in }
    
    
    //스토리보드 생성자
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
     func configureUI() {
        basicView.clipsToBounds = true
        basicView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    // 데이터에 따라 UI 표시하는 메서드
     func configurationUIwithData() {
        memoTextLabel.text = memoData?.memoText
        dateTextLabel.text = memoData?.dateString
        guard let colorNum = memoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .blue
        updateButton.backgroundColor = color.buttonColor
        basicView.backgroundColor = color.backgroundColor
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func updateButtonPressed(_ sender: UIButton) {
        updateButtonPressed(self)
    }
}
