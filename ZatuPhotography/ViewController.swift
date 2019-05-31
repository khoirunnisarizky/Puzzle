//
//  ViewController.swift
//  ZatuPhotography
//
//  Created by khoirunnisa' rizky noor fatimah on 22/04/19.
//  Copyright © 2019 khoirunnisa' rizky noor fatimah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var questionImageArray = [UIImage.init(named: "p11"), UIImage.init(named: "p12"), UIImage.init(named: "p13"), UIImage.init(named: "p14"), UIImage.init(named: "p21"), UIImage.init(named: "p22"), UIImage.init(named: "p23"), UIImage.init(named: "p24"), UIImage.init(named: "p31"), UIImage.init(named: "p32"), UIImage.init(named: "p33"), UIImage.init(named: "p34"), UIImage.init(named: "p41"), UIImage.init(named: "p42"), UIImage.init(named: "p43"), UIImage.init(named: "p44")]
    
    let correctAnswer = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    var wrongAnswer = Array(0..<16)
    var wrongImageArray = [UIImage]()
    var undoMovesArray = [(first: IndexPath, second: IndexPath)]()
    var numberOfMoves = 0
    
    var firstIndexPath: IndexPath?
    var secondIndexPath: IndexPath?
    
    let buttonUndo : UIButton = customButton()
    
    let labelMoves : UILabel = customLabel()
    
    let buttonSwap : UIButton = customButtonSwap()
    
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv =  UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.allowsMultipleSelection = true
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Puzzle Jeffry"
        self.navigationController?.navigationBar.isTranslucent = false
//        print(questionImageArray)
        
        wrongImageArray = questionImageArray as! [UIImage]
        wrongImageArray.shuffle()
        setupViews()
    }
    
    @objc func buttonSwapAction() {
        guard let start = firstIndexPath, let end = secondIndexPath else { return }
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            myCollectionView.moveItem(at: end, to: start)
        }) { (finished) in
            //update data source here
            // print(wrongAns)
            self.myCollectionView.deselectItem(at: start, animated: true)
            self.myCollectionView.deselectItem(at: end, animated: true)
            self.firstIndexPath = nil
            self.secondIndexPath = nil
            self.wrongImageArray.swapAt(start.item, end.item)
            self.wrongAnswer.swapAt(start.item, end.item)
            self.undoMovesArray.append((first: start, second: end))
            self.numberOfMoves += 1
            self.labelMoves.text = "Moves: \(self.numberOfMoves)"
            if self.wrongImageArray == self.questionImageArray {
                let alert = UIAlertController(title: "You Won!", message: "Congratulation!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (action) in self.restartGame()
                })
                alert.addAction(okAction)
                alert.addAction(restartAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func restartGame() {
        self.undoMovesArray.removeAll()
        wrongAnswer = Array(0..<16)
        wrongImageArray = questionImageArray as! [UIImage]
        wrongImageArray.shuffle()
        firstIndexPath = nil
        secondIndexPath = nil
        self.numberOfMoves = 0
        self.labelMoves.text = "Moves: \(numberOfMoves)"
        self.myCollectionView.reloadData()
    }
    
    @objc func buttonUndoAction() {
        if undoMovesArray.count == 0 {
            return //fungsinya agar kalau kepenuhin conditionalnya dia ga ngejalanin yang bawahnya, dalam app ini utk validasi jika user pencet di awal
        }
        let start = undoMovesArray.last!.first //manggil elemen dalam array dengan key name nya
        let end = undoMovesArray.last!.second
        myCollectionView.performBatchUpdates({
            myCollectionView.moveItem(at: start, to: end)
            }) { (finished) in
                //update data soucre here
                self.wrongImageArray.swapAt(start.item, end.item)
                self.wrongAnswer.swapAt(start.item, end.item)
                self.undoMovesArray.removeLast()
                self.numberOfMoves += 1
                self.labelMoves.text = "Moves: \(self.numberOfMoves)"
        }
    }
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if firstIndexPath == nil {
            firstIndexPath = indexPath
            collectionView.selectItem(at: firstIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0)) //raw value : 0
        } else if secondIndexPath == nil {
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        } else {
            collectionView.deselectItem(at: secondIndexPath!, animated: true)
            secondIndexPath = indexPath
            collectionView.selectItem(at: secondIndexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath == firstIndexPath {
            firstIndexPath = nil
        } else if indexPath == secondIndexPath {
            secondIndexPath = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width/4, height: width/4)
    }
    
    
    func setupViews() {
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.register(ImageViewCVCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor = UIColor.white
        
        self.view.addSubview(myCollectionView)
        myCollectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        myCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        myCollectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        myCollectionView.heightAnchor.constraint(equalTo: myCollectionView.widthAnchor, constant: 0).isActive = true
        
        self.view.addSubview(buttonSwap)
        buttonSwap.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonSwap.topAnchor.constraint(equalTo: myCollectionView.bottomAnchor, constant: 20).isActive = true
        buttonSwap.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonSwap.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonSwap.addTarget(self, action: #selector(buttonSwapAction), for: .touchUpInside)
        
        self.view.addSubview(buttonUndo)
        buttonUndo.widthAnchor.constraint(equalToConstant: 200).isActive = true
        buttonUndo.topAnchor.constraint(equalTo: buttonSwap.bottomAnchor, constant: 30).isActive = true
        buttonUndo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        buttonUndo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonUndo.addTarget(self, action: #selector(buttonUndoAction), for: .touchUpInside)
        
        self.view.addSubview(labelMoves)
        labelMoves.widthAnchor.constraint(equalToConstant: 200).isActive = true
        labelMoves.topAnchor.constraint(equalTo: buttonUndo.bottomAnchor, constant: 20).isActive = true
        labelMoves.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        labelMoves.heightAnchor.constraint(equalToConstant: 50).isActive = true
        labelMoves.text = "Moves: \(numberOfMoves)"
        
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageViewCVCell
        cell.imgView.image = wrongImageArray[indexPath.item]
        return cell
    }
    
    


}

