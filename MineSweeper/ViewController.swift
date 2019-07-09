//
//  ViewController.swift
//  MineSweeper
//
//  Created by najmeh nasiriyani on 2019-07-05.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var myGame: Game?
    @IBOutlet var viewButtons: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()
        for index in viewButtons.indices{
            let button = viewButtons[index]
            let image = UIImage(named: "lightGreyBackground")
            button.setBackgroundImage(image, for: .normal)
            
        }
        // Do any additional setup after loading the view.
        startNewGame()
        
    }
    @IBAction func restartGame(_ sender: UIButton) {
        startNewGame()
        updateView()
    }
    func startNewGame(){
        for index in viewButtons.indices{
            self.viewButtons[index].isEnabled = true
        }
         myGame = Game(cellNums: 54,colsNum: 6, mines: 10)
    }
    @IBAction func revealButton(_ sender: UIButton) {
        if let cellNumber = viewButtons.firstIndex(of: sender){
            print(cellNumber)
            if !(myGame!.revealCell(cellNumber)){
                endGame(theBomb: cellNumber)
                //startNewGame()
            }
            else{updateView()}
        }
    }
    func endGame(theBomb currentCell: Int){
        for index in viewButtons.indices{
            self.viewButtons[index].setTitle("⬜️", for: .normal)
            self.viewButtons[index].isEnabled = false
        }
        self.viewButtons[currentCell].setTitle("💣", for: .normal)
    }
    func updateView(){
        for cellIndex in myGame!.cells.indices{
            self.viewButtons[cellIndex].setTitle("⬛️", for: .normal)
            if myGame!.cells[cellIndex].revealed{
                let neighbors = myGame!.neighborBombs(index: cellIndex)
                if neighbors > 0 {
                    self.viewButtons[cellIndex].setTitle(String(neighbors), for: .normal)
                } else {
                    self.viewButtons[cellIndex].setTitle("", for: .normal)
                }
            }
        }
    }
    
}

