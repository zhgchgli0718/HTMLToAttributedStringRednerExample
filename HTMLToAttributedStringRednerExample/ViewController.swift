//
//  ViewController.swift
//  HTMLToAttributedStringRednerExample
//
//  Created by ZhgChgLi on 2022/6/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stripResult: UILabel!
    @IBOutlet weak var renderResult: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let test = "我<br/><a href=\"http://google.com\">同意</a>提供<b><i>個</i>人</b>身分證字號／護照／居留<span style=\"color:#FF0000;font-size:20px;word-spacing:10px;line-height:10px\">證號碼</span>，以供<i>跨境物流</i>方通關<span style=\"background-color:#00FF00;\">使用</span>，並已<img src=\"g.png\"/>了解跨境<br/>商品之物<p>流需</p>求"

        let stripper = try! HTMLStripper(string: test)
        stripResult.text = try! stripper.parse()
        
        let render = HTMLToAttributedStringParser(defaultStyle: DefaultTextStyle())
        render.register(ATagParser())
        render.register(BoldTagParser())
        render.register(SpanTagParser())
        //...
        
        renderResult.attributedText = try! render.parse(string: test)
        print(renderResult.attributedText)
    }
}

