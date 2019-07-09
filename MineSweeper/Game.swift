//
//  Game.swift
//  MineSweeper
//
//  Created by najmeh nasiriyani on 2019-07-05.
//  Copyright © 2019 najmeh nasiriyani. All rights reserved.
//

import Foundation

class Game{
    enum GameState{
        case clickedBomb
        case youWon
        case onGoing
    }
    var gameState : GameState = .onGoing
    var cells : [Cell]
    let cols : Int
    init(cellNums: Int, colsNum:Int, mines: Int){
        self.cells = Array()
        self.cols = colsNum
        var minecells = Set<Int>()
        var myrand: Int
        for _ in 1...mines{
            repeat{ myrand = cellNums.random
            }while minecells.contains(myrand)
            minecells.insert(myrand)
        }
        for i in 0...cellNums - 1{
            cells.append(Cell(hasMine: minecells.contains(i), revealed: false))
        }
    }
    subscript(row: Int, col: Int) -> Cell?{
        get{
            return cells[row * col + col]
        }
        set{
            if newValue != nil { cells[row * col + col] = newValue!}
        }
    }
    func neighborBombs(index: Int) ->Int{
        var bombCount = 0
        let row = index / self.cols
        let col = index % self.cols
        var rowRange = -1...1
        var colRange = -1...1
        let addRange = 0...1
        let minRange = -1...0
        if row == 0 {rowRange = addRange}
            else if row == cells.count / cols {rowRange = minRange}
        if col == 0 {colRange = addRange}
        else if col == cols-1 {colRange = minRange}
        
        for i in rowRange{
            for j in colRange{
                if !(i==0 && j==0){
                    let nindex = (row + i) * (cols) + (col + j)
                    if nindex >= 0 && nindex < cells.count {
                        if cells[nindex].hasMine{
                            bombCount += 1
                            print("counting bombs for: \(index): the bomb is in: \(nindex)")
                        }
                    }
                }
                }
            }
        return bombCount
    }
    func myNeighbors(_ index: Int) -> [Int]{
        var neighborCells = [Int]()
        let row = index / self.cols
        let col = index % self.cols
        var rowRange = -1...1
        var colRange = -1...1
        let addRange = 0...1
        let minRange = -1...0
        if row == 0 {rowRange = addRange}
        else if row == cells.count / cols {rowRange = minRange}
        if col == 0 {colRange = addRange}
        else if col == cols-1 {colRange = minRange}
        
        for i in rowRange{
            for j in colRange{
                if !(i==0 && j==0){
                    let index = (row + i) * (cols) + (col + j)
                    if index >= 0 && index < cells.count {neighborCells.append(index)}
                }
            }
        }
        return neighborCells
    }
    func revealCell(_ currentCell: Int)-> Bool{
        print("revealing cell: \(currentCell)")
        if self.cells[currentCell].hasMine {
            gameState = .clickedBomb
            return false
        } else{
            self.cells[currentCell].revealed = true
            let neighbors = neighborBombs(index: currentCell)
            if neighbors == 0 {
                for neighbor in myNeighbors(currentCell){
                    if !self.cells[neighbor].revealed{
                        print("Revealing the neighbor: \(neighbor)")
                        revealCell(neighbor)
                        self.cells[neighbor].revealed = true
                    }
                }
            }
        }
        return true
    }
}


extension Int{
    var random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {return 0}
    }
}
